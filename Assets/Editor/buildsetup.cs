using UnityEditor;
using UnityEngine;

public class SovereignBuildTools
{
[MenuItem("Tools/Build Game &w")]
public static void BuildProject()
{
string[] scenes = { "Assets/Scenes/game.unity" };
BuildPipeline.BuildPlayer(scenes, "build/deathmatch.x86_64", BuildTarget.StandaloneLinux64, BuildOptions.None);
BuildPipeline.BuildPlayer(scenes, "build/windows/deathmatch.exe", BuildTarget.StandaloneWindows64, BuildOptions.None);
BuildPipeline.BuildPlayer(scenes, "build/mac/deathmatch.app", BuildTarget.StandaloneOSX, BuildOptions.None);
}
}
