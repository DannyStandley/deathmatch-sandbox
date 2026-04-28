using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using System.Collections.Generic;

public class ForceIncludeShaders : Editor
{
    // List all the built-in shader names you need for your game.
    private static List<string> builtInShaderNames = new List<string>
    {
        "Standard",
        "Standard (Specular setup)",
        "Unlit/Color",
        "Unlit/Texture",
        "Unlit/Transparent",
        "Skybox/6 Sided",
        "Skybox/Panoramic",
        "Skybox/Procedural",
        "Nature/Terrain/Standard",
        "Sprites/Default",
        // Add any other specific shaders you might use
    };

    [MenuItem("Tools/Force Include Built-in Shaders")]
    public static void AddAllBuiltInShadersToAlwaysIncluded()
    {
        var graphicsSettingsObj = AssetDatabase.LoadAssetAtPath<GraphicsSettings>("ProjectSettings/GraphicsSettings.asset");
        if (graphicsSettingsObj == null)
        {
            Debug.LogError("GraphicsSettings.asset not found!");
            return;
        }

        var serializedObject = new SerializedObject(graphicsSettingsObj);
        var arrayProp = serializedObject.FindProperty("m_AlwaysIncludedShaders");

        // Clear existing list if desired, or just append
        arrayProp.ClearArray();

        foreach (string shaderName in builtInShaderNames)
        {
            Shader shader = Shader.Find(shaderName);
            if (shader == null)
            {
                Debug.LogWarning($"Shader '{shaderName}' not found in project, skipping inclusion.");
                continue;
            }

            bool hasShader = false;
            for (int i = 0; i < arrayProp.arraySize; ++i)
            {
                if (shader == arrayProp.GetArrayElementAtIndex(i).objectReferenceValue)
                {
                    hasShader = true;
                    break;
                }
            }

            if (!hasShader)
            {
                int index = arrayProp.arraySize;
                arrayProp.InsertArrayElementAtIndex(index);
                arrayProp.GetArrayElementAtIndex(index).objectReferenceValue = shader;
                Debug.Log($"Added {shaderName} to Always Included Shaders.");
            }
        }

        serializedObject.ApplyModifiedProperties();
        AssetDatabase.SaveAssets(); // Save the changes to the project settings file
        Debug.Log("Finished updating Always Included Shaders list.");
    }

    // You can also hook this into your specific build pipeline via build callbacks
    // or simply run the menu item before initiating a build.
}

