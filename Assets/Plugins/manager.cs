using DavyKager;
using LiteNetLib;
using LiteNetLib.Utils;
using UnityEngine;
using UnityEngine.Scripting;
using UnityEngine.InputSystem;
using UnityEngine.Rendering;
using UnityEngine.Networking;
using UnityEngine.Video;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using NLua;
public class sound : MonoBehaviour
{
public AudioClip clip;
public AudioSource source;
private void Awake()
{
source = gameObject.AddComponent<AudioSource>();
source.dopplerLevel = 0f;
}
public void load(string soundfile, int looping, int stereopan, int usereverb, bool streaming)
{
AudioClip clip = GameObject.Find("Game Manager").GetComponent<manager>().loadsound(soundfile, streaming);
source.clip = clip;
gameObject.AddComponent<AudioLowPassFilter>();
gameObject.GetComponent<AudioLowPassFilter>().cutoffFrequency = 2500f;
gameObject.GetComponent<AudioLowPassFilter>().enabled = false;
gameObject.AddComponent<AudioHighPassFilter>();
gameObject.GetComponent<AudioHighPassFilter>().cutoffFrequency = 1000f;
gameObject.GetComponent<AudioHighPassFilter>().enabled = false;
gameObject.AddComponent<AudioDistortionFilter>();
gameObject.GetComponent<AudioDistortionFilter>().distortionLevel = 0.5f;
gameObject.GetComponent<AudioDistortionFilter>().enabled = false;
if(looping==1)
{
source.loop = true;
}
if(stereopan==0)
{
source.spatialBlend = 1;
}
if(usereverb==0)
{
source.bypassReverbZones = true;
}
}
}

public class SoundManager : MonoBehaviour
{
public GameObject playsound;
public List<GameObject> playlist;
public List<GameObject> sounds;
private GameObject soundprefab;
public void setvolume(GameObject soundnum, float vol)
{
soundnum.GetComponent<sound>().source.volume = vol;
}
public void pausesound(GameObject soundnum)
{
soundnum.GetComponent<sound>().source.Pause();
}
private void Awake()
{
playlist = new List<GameObject>();
sounds = new List<GameObject>();
soundprefab = new GameObject();
soundprefab.AddComponent<sound>();
}
public GameObject load(double x, double y, double z, string soundfile, int looping, int stereopan, int usereverb, int bypass=0, bool streaming=false)
{
GameObject sound1 = Instantiate(soundprefab, new Vector3(System.Convert.ToSingle(x), System.Convert.ToSingle(z), System.Convert.ToSingle(y)), Quaternion.identity);
sound1.GetComponent<sound>().load(soundfile, looping, stereopan, usereverb, streaming);
if(bypass==1)
{
sound1.GetComponent<sound>().source.bypassListenerEffects = true;
}
sounds.Add(sound1);
return sound1;
}
public void play(GameObject soundnum)
{
soundnum.GetComponent<sound>().source.Play();
}
public void stop(GameObject soundnum)
{
soundnum.GetComponent<sound>().source.Stop();
}
public void freesound(GameObject soundnum)
{
sounds.Remove(soundnum);
if(soundnum.GetComponent<sound>().clip!=null)
{
soundnum.GetComponent<sound>().clip.UnloadAudioData();
}
GameObject.Destroy(soundnum);
}
public int checkplaying(GameObject soundnum)
{
if(soundnum.GetComponent<sound>().source.isPlaying==true)
{
return 1;
}
return 0;
}
public List<GameObject> getsounds()
{
return sounds;
}
public int soundcount()
{
return sounds.Count;
}
public void movesound(GameObject soundnum, float posx, float posy, float posz)
{
soundnum.transform.position = new Vector3(posx, posz, posy);
}
public void setpitch(GameObject soundnum, float pitch)
{
soundnum.GetComponent<sound>().source.pitch = pitch;
}
public void Update()
{
if(playsound==null&&checkqueue()>0)
{
playsound = playlist[0];
playsound.GetComponent<sound>().source.Play();
}
if(playsound!=null&&playsound.GetComponent<sound>().source.isPlaying==false)
{
playlist.Remove(playsound);
playsound = null;
}
}
public int checkqueue()
{
return playlist.Count;
}
public void playsoundwait(GameObject soundnum)
{
playlist.Add(soundnum);
}
public void spatialsound(GameObject soundnum, float space)
{
soundnum.GetComponent<sound>().source.spatialBlend = space;
}
public void radiosound(GameObject soundnum, int distort)
{
soundnum.GetComponent<AudioHighPassFilter>().enabled = true;
if(distort==1)
{
soundnum.GetComponent<AudioDistortionFilter>().enabled = true;
}
}
public void unradiosound(GameObject soundnum, int distort)
{
soundnum.GetComponent<AudioHighPassFilter>().enabled = false;
if(distort==1)
{
soundnum.GetComponent<AudioDistortionFilter>().enabled = false;
}
}
public void mufflesound(GameObject soundnum, int noreverb)
{
soundnum.GetComponent<AudioLowPassFilter>().enabled = true;
if(noreverb==1)
{
soundnum.GetComponent<sound>().source.bypassReverbZones = true;
}
}
public void unmufflesound(GameObject soundnum, int noreverb)
{
soundnum.GetComponent<AudioLowPassFilter>().enabled = false;
if(noreverb==1)
{
soundnum.GetComponent<sound>().source.bypassReverbZones = false;
}
}
}
public class server
{
public string addr = "";
public int port = 0;
public List<string> messages;
public EventBasedNetListener listener;
public NetManager netmanager;
public NetPeer sendserver;
public server(string addr, int port)
{
this.messages = new List<string>();
this.listener = new EventBasedNetListener();
this.netmanager = new NetManager(this.listener);
netmanager.Start();
netmanager.Connect(addr, port, "");
listener.PeerConnectedEvent += peer =>
{
sendserver = peer;
};
listener.NetworkReceiveEvent += (fromPeer, dataReader, deliveryMethod) =>
{
messages.Add(dataReader.GetString());
dataReader.Recycle();
};
}
public void send(string text)
{
NetDataWriter writer = new NetDataWriter();
writer.Put(text);
sendserver.Send(writer, DeliveryMethod.Unreliable);
}
}
public class mapfunctions : MonoBehaviour
{
public void attachvideo(GameObject obj, string videofile)
{
obj.AddComponent<AudioSource>();
obj.AddComponent<VideoPlayer>();
obj.GetComponent<VideoPlayer>().playOnAwake = false;
obj.GetComponent<VideoPlayer>().source = VideoSource.Url;
obj.GetComponent<VideoPlayer>().renderMode = VideoRenderMode.MaterialOverride;
obj.GetComponent<VideoPlayer>().targetMaterialRenderer = obj.GetComponent<Renderer>();
obj.GetComponent<VideoPlayer>().targetMaterialProperty = "_MainTex";
obj.GetComponent<VideoPlayer>().audioOutputMode = VideoAudioOutputMode.AudioSource;
obj.GetComponent<VideoPlayer>().url = globals.initdir+"/../"+videofile;
obj.GetComponent<VideoPlayer>().Prepare();
}
public bool isvideoplaying(GameObject obj)
{
return obj.GetComponent<VideoPlayer>().isPlaying;
}
public void stopvideo(GameObject obj)
{
obj.GetComponent<VideoPlayer>().Stop();
}
public void playvideo(GameObject obj)
{
obj.GetComponent<VideoPlayer>().Play();
}
public void destroyobj(GameObject obj)
{
if(obj==null)
{
return;
}
if(obj!=null)
{
if(obj.GetComponent<misc>()!=null&&obj.GetComponent<misc>().foundmap!=null)
{
obj.GetComponent<misc>().foundmap.mapobjects.Remove(obj);
}
if(obj.GetComponent<misc>()!=null&&obj.GetComponent<misc>().block!=null)
{
globals.blockpoints.Remove(obj.GetComponent<misc>().block);
}
globals.mapobjects.Remove(obj);
GameObject.Destroy(obj);
}
}
public void changeobjcolor(GameObject obj, float r, float g, float b, float a)
{
obj.GetComponent<SpriteRenderer>().color = new Color(r, g, b, a);
}
public void changescale(GameObject obj, float x, float y, float z)
{
obj.transform.localScale = new Vector3(x, y, z);
}
public void moveobj(GameObject obj, float x, float y, float z)
{
obj.transform.position = new Vector3(x, z, y);
}
public GameObject spawnobject(float x, float y, float z, float orientx, float orienty, float orientz, GameObject obj, int block, string mapname, Material material=null)
{
blockpoint newblock = null;
if(block==1)
{
newblock = new blockpoint();
newblock.x = x;
newblock.y = y;
newblock.z = z;
globals.blockpoints.Add(newblock);
}
GameObject obj1 = Instantiate(obj, new Vector3(x, z, y), Quaternion.Euler(orientx, orienty, orientz));
obj1.name = obj.name;
obj1.transform.localScale = new Vector3(obj.transform.localScale.x, obj.transform.localScale.y, obj.transform.localScale.z);
if(material!=null)
{
foreach(MeshRenderer a in obj1.GetComponentsInChildren<MeshRenderer>())
{
a.material = material;
}
}
misc miscinfo = obj1.AddComponent<misc>().GetComponent<misc>();
miscinfo.orientx = orientx;
miscinfo.orienty = orienty;
miscinfo.orientz = orientz;
miscinfo.block = newblock;
if(newblock!=null)
{
newblock.obj = miscinfo;
}
miscinfo.orgx = x;
miscinfo.orgy = y;
miscinfo.orgz = z;
miscinfo.mapname = mapname;
globals.mapobjects.Add(obj1);
foreach(map a in globals.maps)
{
if(a.name==mapname)
{
a.mapobjects.Add(obj1);
}
}
return obj1;
}
public void changeobjectcolor(GameObject obj, float r, float g, float b, float a)
{
if(obj.GetComponent<MeshRenderer>()!=null)
{
obj.GetComponent<MeshRenderer>().material.color = new Color(r, g, b, a);
}
}
public void destroyobjects(float x, float y, float z, float maxx, float maxy, float maxz)
{
List<runscript> remscripts = new List<runscript>();
foreach(runscript a in globals.runscripts)
{
if(a.x>=maxx&&a.maxx<=maxx&&a.y>=maxy&&a.maxy<=maxy&&a.z>=z&&a.maxz<=maxz)
{
remscripts.Add(a);
}
}
foreach(runscript a in remscripts)
{
globals.runscripts.Remove(a);
}
remscripts.Clear();
List<GameObject> remobjs = new List<GameObject>();
foreach(GameObject a in globals.mapobjects)
{
if(a.transform.position.x>=x&&a.transform.position.x<=maxx&&a.transform.position.z>=y&&a.transform.position.z<=maxy&&a.transform.position.y>=z&&a.transform.position.y<=maxz)
{
remobjs.Add(a);
}
}
foreach(GameObject a in remobjs)
{
destroyobj(a);
}
remobjs.Clear();
}
public void spawnrunscript(float x, float y, float z, float maxx, float maxy, float maxz, string script, string mapname)
{
map foundmap = gameObject.GetComponent<manager>().findmap(mapname);
runscript newscript = new runscript();
newscript.x = foundmap.x +x;
newscript.y = foundmap.y +y;
newscript.z = foundmap.z +z;
newscript.maxx = foundmap.x +maxx;
newscript.maxy = foundmap.y +maxy;
newscript.maxz = foundmap.z +maxz;
newscript.orgx = x;
newscript.orgy = y;
newscript.orgz = z;
newscript.orgmaxx = maxx;
newscript.orgmaxy = maxy;
newscript.orgmaxz = maxz;
newscript.script = script;
newscript.mapname = mapname;
globals.runscripts.Add(newscript);
foundmap.runscripts.Add(newscript);
}
public void spawnblock(float x, float y, float z)
{
blockpoint newblock = new blockpoint();
newblock.x = x;
newblock.y = y;
newblock.z = z;
globals.blockpoints.Add(newblock);
}
public void changeobjectmaterial(GameObject obj, Material mat)
{
obj.GetComponent<MeshRenderer>().material = mat;
}
public GameObject createplane()
{
GameObject plane = GameObject.CreatePrimitive(PrimitiveType.Plane);
plane.transform.localScale = new Vector3(0.3f, 1, 0.3f);
plane.name = "plane";
return plane;
}
public GameObject createcube()
{
GameObject obj = GameObject.CreatePrimitive(PrimitiveType.Cube);
obj.name = "cube";
return obj;
}
public GameObject createmodel(string filename)
{
GameObject newmod = new GameObject();
newmod.AddComponent<MeshRenderer>();
newmod.AddComponent<MeshFilter>();
newmod.GetComponent<MeshFilter>().mesh = gameObject.GetComponent<manager>().loadmodel(filename);
return newmod;
}
public void hideobject(GameObject obj)
{
obj.SetActive(false);
}
public void showobject(GameObject obj)
{
obj.SetActive(true);
}
public string gettext(GameObject text1)
{
return text1.GetComponent<TextMesh>().text;
}
public void spawnlocation(float x, float y, float z, float maxx, float maxy, float maxz, string name, string mapname)
{
map foundmap = gameObject.GetComponent<manager>().findmap(mapname);
location newlocation = new location();
newlocation.x = foundmap.x +x;
newlocation.y = foundmap.y +y;
newlocation.z = foundmap.z +z;
newlocation.maxx = foundmap.x +maxx;
newlocation.maxy = foundmap.y +maxy;
newlocation.maxz = foundmap.z +maxz;
newlocation.orgx = x;
newlocation.orgy = y;
newlocation.orgz = z;
newlocation.orgmaxx = maxx;
newlocation.orgmaxy = maxy;
newlocation.orgmaxz = maxz;
newlocation.name = name;
newlocation.mapname = mapname;
foundmap.locations.Add(newlocation);
globals.locations.Add(newlocation);
}
public void spawnobjects(float minx, float miny, float minz, float maxx, float maxy, float maxz, float orientx, float orienty, float orientz, GameObject obj, int block, string mapname, Material mat=null)
{
for(float a=minx; a<=maxx; ++a)
{
spawnobject(a, miny, minz, orientx, orienty, orientz, obj, block, mapname, mat);
if(miny!=maxy)
{
for(float m=miny +1; m<=maxy; ++m)
{
spawnobject(a, m, minz, orientx, orienty, orientz, obj, block, mapname, mat);
if(minz!=maxz)
{
for(float y=minz +1; y<=maxz; ++y)
{
spawnobject(a, m, y, orientx, orienty, orientz, obj, block, mapname, mat);
}
}
}
}
if(minz!=maxz)
{
for(float y=minz +1; y<=maxz; ++y)
{
spawnobject(a, miny, y, orientx, orienty, orientz, obj, block, mapname, mat);
}
}
}
}
public void attachsound(string soundfile, GameObject obj)
{
AudioSource source = obj.AddComponent<AudioSource>();
AudioClip sound = gameObject.GetComponent<manager>().loadsound(soundfile);
source.clip = sound;
source.loop = true;
source.Play();
source.spatialBlend = 1;
source.dopplerLevel = 0f;
}
public void attachtext(GameObject obj, string text, float charsize)
{
obj.AddComponent<TextMesh>();
obj.GetComponent<TextMesh>().text = text;
obj.GetComponent<TextMesh>().characterSize = charsize;
}
public void changetext(GameObject obj, string text, float charsize)
{
obj.GetComponent<TextMesh>().text = text;
obj.GetComponent<TextMesh>().characterSize = charsize;
}
public GameObject createobject()
{
return new GameObject();
}
public void followobject(GameObject obj1, GameObject obj2)
{
obj1.transform.position = new Vector3(obj2.transform.position.x, obj2.transform.position.y, obj2.transform.position.z);
}
public void addstate(map foundmap, string statename)
{
foundmap.states.Add(statename);
}
public void removestate(map foundmap, string statename)
{
List<string> removestates = new List<string>();
foreach(string a in foundmap.states)
{
if(a==statename)
{
removestates.Add(a);
}
}
foreach(string a in removestates)
{
foundmap.states.Remove(a);
}
}
public int checkstate(map checkmap, string state)
{
foreach(string a in checkmap.states)
{
if(a==state)
{
return 1;
}
}
return 0;
}
public string checkstatetext(map checkmap, string state)
{
foreach(string a in checkmap.states)
{
if(a.Split(" ")[0]==state)
{
return a.Replace(state+" ", "");
}
}
return "";
}
public void clearalltext(string mapname)
{
map foundmap = gameObject.GetComponent<manager>().findmap(mapname);
List<GameObject> destobjs = new List<GameObject>();
foreach(GameObject a in foundmap.mapobjects)
{
if(a==null||a.GetComponent<MeshRenderer>()==null||a.GetComponent<TextMesh>()!=null&&a.GetComponent<MeshRenderer>().enabled==true)
{
if(a.GetComponent<misc>().checkstate("dontclear")==0)
{
destobjs.Add(a);
}
}
}
foreach(GameObject a in destobjs)
{
if(a.GetComponent<misc>()!=null&&a.GetComponent<misc>().block!=null)
{
globals.blockpoints.Remove(a.GetComponent<misc>().block);
}
foundmap.mapobjects.Remove(a);
globals.mapobjects.Remove(a);
GameObject.Destroy(a);
}
}

public void attachlight(GameObject obj, string type)
{
if(obj.GetComponent<Light>()==null)
{
obj.AddComponent<Light>();
}
obj.GetComponent<Light>().renderMode = LightRenderMode.ForcePixel;
obj.GetComponent<Light>().shadowBias = 0f;
obj.GetComponent<Light>().shadowNormalBias = 0f;
obj.GetComponent<Light>().cullingMask = -1;
if(type=="spot")
{
obj.GetComponent<Light>().type = LightType.Spot;
}
else if(type=="directional")
{
obj.GetComponent<Light>().type = LightType.Directional;
}
else
{
obj.GetComponent<Light>().type = LightType.Point;
}
}
public void enablelight(GameObject obj)
{
obj.GetComponent<Light>().enabled = true;
}
public void disablelight(GameObject obj)
{
obj.GetComponent<Light>().enabled = false;
}
public void setlightrange(GameObject obj, float range)
{
obj.GetComponent<Light>().range = range;
}
public void setlightcolor(GameObject obj, float r, float g, float b, float a)
{
obj.GetComponent<Light>().color = new Color(r, g, b, a);
}
public void setlightintensity(GameObject obj, float intensity)
{
obj.GetComponent<Light>().intensity = intensity;
}
public void enablefog(float r, float g, float b, float a, float startdist, float enddist)
{
RenderSettings.fog = true;
RenderSettings.fogColor = new Color(r, g, b, a);
RenderSettings.fogMode = FogMode.Linear;
RenderSettings.fogStartDistance = startdist;
RenderSettings.fogEndDistance = enddist;
}
public void disablefog()
{
RenderSettings.fog = false;
}
public void enableexponentialfog(float r, float g, float b, float a, float density)
{
RenderSettings.fog = true;
RenderSettings.fogColor = new Color(r, g, b, a);
RenderSettings.fogDensity = density;
RenderSettings.fogMode = FogMode.ExponentialSquared;
}
public GameObject getobj(float x, float y, float z, string name, map foundmap)
{
if(foundmap==null)
{
return null;
}
foreach(GameObject a in foundmap.mapobjects)
{
if(a!=null&&a.name==name)
{
misc obj = a.GetComponent<misc>();
if(obj!=null&&obj.orgx==x&&obj.orgy==y&&obj.orgz==z||obj!=null&&obj.transform.position.x==x&&obj.transform.position.z==y&&obj.transform.position.y==z)
{
return a;
}
}
}
return null;
}
public misc getmisc(GameObject obj)
{
return obj.GetComponent<misc>();
}
public List<GameObject> getallobjects()
{
return globals.mapobjects;
}
}
public class ship : MonoBehaviour
{
public double galx = 0f;
public double galy = 0f;
public double galz = 0f;
public List<map> maps;
public string dir = "";
public float acc = 0;
public float pitch = 0f;
public float shipx = 0f;
public float shipy = 0f;
public float shipz = 0f;
public int saveable = 0;
public List<String> states;
public string shipname = "";
public string location = "";
public AudioSource source;
public AudioClip enginesound;
public string saveenginesound = "";
public float speed = 0f;
public float desiredspeed = 0f;
public float maxspeed = 0f;
public float power = 0f;
public float desiredpower = 0f;
private void Start()
{
GameObject.Find("Game Manager").GetComponent<manager>().addfunction("scripts/ship/movement.lua", "update", shipname);
}
public int checkstate(string state)
{
foreach(string a in states)
{
if(a==state)
{
return 1;
}
}
return 0;
}
public void addstate(string state)
{
states.Add(state);
}
public void removestate(string state)
{
string newstate = "";
foreach(string a in states)
{
if(a==state)
{
newstate = a;
}
}
if(newstate!="")
{
states.Remove(state);
}
}
public void setupsounds()
{
if(saveenginesound!="")
{
enginesound = GameObject.Find("Game Manager").GetComponent<manager>().loadsound(saveenginesound);
}
source = gameObject.AddComponent<AudioSource>();
if(enginesound!=null)
{
source.clip = enginesound;
source.loop = true;
}
}
public string checkstatetext(string statename)
{
foreach(string a in states)
{
if(a.Split(" ")[0]==statename)
{
return a.Replace(statename+" ", "");
}
}
return "";
}
public void acceleration()
{
float getacc = 1000000f /100f *acc;
if(desiredpower>100f)
{
desiredpower = 100f;
}
if(power<0f)
{
power = 0f;
}
if(power==0f&&pitch!=1f)
{
pitch = 1f;
}
if(desiredpower>100f)
{
desiredpower = 100f;
}
if(speed<0)
{
speed = 0;
}
if(desiredspeed<0)
{
desiredspeed = 0;
}
if(desiredspeed>maxspeed)
{
desiredspeed = maxspeed;
}
if(speed>desiredspeed)
{
speed -= 1 *0.01f *0.01f *getacc;
if(speed<desiredspeed)
{
speed = System.Convert.ToInt64(desiredspeed);
}
}
if(speed<desiredspeed)
{
speed += 1 *0.01f *0.01f *getacc;
if(speed>desiredspeed)
{
speed = System.Convert.ToInt64(desiredspeed);
}
}
desiredpower = speed /maxspeed *100;
}
public void powerloop()
{
if(power<desiredpower)
{
power += 1;
pitch += 0.01f;
}
if(power>desiredpower)
{
power -= 1;
pitch -= 0.01f;
}
if(power==100f&&pitch<1f)
{
pitch = 2f;
}
if(power<=0f&&pitch!=1f)
{
pitch = 1f;
}
if(source!=null)
{
source.pitch = pitch;
}
if(source!=null&&System.Convert.ToInt64(power)==0&&source.pitch!=1f)
{
source.pitch = 1f;
}
}
}
public class PlayerController : MonoBehaviour
{
public string area = "";
public map foundmap;
public float orgx = 0f;
public float orgy = 0f;
public float orgz = 0f;
public string curtype = "";
public string filename = "";
private manager gamemanager;
private luafunctions luaf;
public float neworgx = 0f;
public float neworgy = 0f;
public float neworgz = 0f;
public List<string> states;
public float x = 0f;
public float y = 0f;
public float z = 0f;
public float theta = 0f;
public float ztheta = 0f;
public GameObject reverbzone;
public string playername = "";
public string location = "";
private GameObject maincamera;
private int stepnum = 0;
private int oldstepnum = -1;
public List<AudioClip> stepsounds;
public AudioSource stepsource;
private void Awake()
{
luaf = GameObject.Find("Game Manager").GetComponent<luafunctions>();
gamemanager = GameObject.Find("Game Manager").GetComponent<manager>();
maincamera = GameObject.Find("Main Camera");
if(maincamera.GetComponent<AudioLowPassFilter>()==null)
{
maincamera.AddComponent<AudioLowPassFilter>();
maincamera.GetComponent<AudioLowPassFilter>().cutoffFrequency = 100f;
maincamera.GetComponent<AudioLowPassFilter>().enabled = false;
}
states = new List<string>();
reverbzone = new GameObject();
reverbzone.AddComponent<AudioReverbZone>();
stepsounds = new List<AudioClip>();
}
private void Start()
{
maincamera.GetComponent<Camera>().orthographicSize = (20.0f / Screen.width *Screen.height / 2.0f);
stepsource = gameObject.AddComponent<AudioSource>();
stepsource.dopplerLevel = 0f;
}
public void updatecoords()
{
foundmap = gamemanager.findmap(location);
if(foundmap!=null)
{
neworgx = foundmap.x +orgx;
neworgy = foundmap.y +orgy;
neworgz = foundmap.z +orgz;
x = neworgx;
y = neworgy;
z = neworgz;
}
}
public void playstepsounds()
{
if(stepsounds.Count==0)
{
return;
}
while(oldstepnum==stepnum)
{
stepnum = UnityEngine.Random.Range(0, stepsounds.Count);
}
stepsource.PlayOneShot(stepsounds[stepnum]);
oldstepnum = stepnum;
if(stepsounds.Count==1)
{
oldstepnum = -1;
}
}
public void load(string pname)
{
filename = name;
string file = System.IO.File.ReadAllText(globals.initdir+"/../characters/"+pname);
string[] filestr = file.Split('\n');
for(int a=0; a<filestr.Length; ++a)
{
filestr[a] = filestr[a].Replace("\r", "").Replace("\n", "");
}
for(int a=0; a<filestr.Length; ++a)
{
if(filestr[a].Length>=5&&filestr[a].Substring(0, 5)=="state")
{
string statestr = filestr[a].Substring(6).Replace("\n", "").Replace("\r", "").Replace(System.Environment.NewLine, "");
if(checkstate(statestr)==0)
{
states.Add(statestr);
}
}
if(filestr[a].Length>=5&&filestr[a].Substring(0, 5)=="theta")
{
theta = System.Convert.ToSingle(filestr[a].Substring(6));
}
if(filestr[a].Length>=4&&filestr[a].Substring(0, 4)=="name")
{
playername = filestr[a].Substring(5).Replace("\n", "").Replace("\r", "").Replace(System.Environment.NewLine, "");
filename = playername;
}
if(filestr[a].Length>=1&&filestr[a].Substring(0, 1)=="x")
{
orgx = System.Convert.ToSingle(filestr[a].Substring(2));
}
if(filestr[a].Length>=1&&filestr[a].Substring(0, 1)=="y")
{
orgy = System.Convert.ToSingle(filestr[a].Substring(2));
}
if(filestr[a].Length>=1&&filestr[a].Substring(0, 1)=="z")
{
orgz = System.Convert.ToSingle(filestr[a].Substring(2));
}
if(filestr[a].Length>=5&&filestr[a].Substring(0, 5)=="theta")
{
theta = System.Convert.ToSingle(filestr[a].Substring(6));
}
if(filestr[a].Length>=6&&filestr[a].Substring(0, 6)=="lookup")
{
ztheta = System.Convert.ToSingle(filestr[a].Substring(7));
}
if(filestr[a].Length>=8&&filestr[a].Substring(0, 8)=="location")
{
location = filestr[a].Substring(9).Replace("\n", "").Replace("\r", "").Replace(System.Environment.NewLine, "");
}}
}
public void save()
{
if(System.IO.File.Exists(globals.initdir+"/../characters/"+filename)==true)
{
System.IO.File.Delete(globals.initdir+"/../characters/"+filename);
}
var newfile = System.IO.File.CreateText(globals.initdir+"/../characters/"+filename);
newfile.WriteLine("name "+playername);
foreach(string a in states)
{
newfile.WriteLine("state "+a);
}
newfile.WriteLine("location "+location);
newfile.WriteLine("x "+orgx);
newfile.WriteLine("y "+orgy);
newfile.WriteLine("z "+orgz);
newfile.WriteLine("theta "+System.Convert.ToString(theta));
newfile.WriteLine("lookup "+System.Convert.ToString(ztheta));
newfile.Flush();
newfile.Close();
}
public void loadsteps(string type)
{
stepsounds.Clear();
stepnum = 0;
if(type=="")
{
return;
}
string[] files = System.IO.Directory.GetFiles(globals.initdir+"/../"+type);
for(int a=1; a<files.Length +1; ++a)
{
AudioClip stepsound = GameObject.Find("Game Manager").GetComponent<manager>().loadsound(type+"/step"+System.Convert.ToString(a)+".ogg");
stepsounds.Add(stepsound);
}
}
public void walk(string dir, float speed)
{
float tempx = orgx;
float tempy = orgy;
float tempz = orgz;
if(dir=="forward")
{
tempx += System.Convert.ToSingle(System.Math.Round(System.Math.Sin(theta *System.Math.PI /180)) *0.001 *speed);
tempy += System.Convert.ToSingle(System.Math.Round(System.Math.Cos(theta *System.Math.PI /180)) *0.001 *speed);
}
if(dir=="backward")
{
tempx -= System.Convert.ToSingle(System.Math.Round(System.Math.Sin(theta *System.Math.PI /180)) *0.001 *speed);
tempy -= System.Convert.ToSingle(System.Math.Round(System.Math.Cos(theta *System.Math.PI /180)) *0.001 *speed);
}
if(dir=="left")
{
tempx -= System.Convert.ToSingle(System.Math.Round(System.Math.Sin((theta +90) *System.Math.PI /180)) *0.001 *speed);
tempy -= System.Convert.ToSingle(System.Math.Round(System.Math.Cos((theta +90) *System.Math.PI /180)) *0.001 *speed);
}
if(dir=="right")
{
tempx += System.Convert.ToSingle(System.Math.Round(System.Math.Sin((theta +90) *System.Math.PI /180)) *0.001 *speed);
tempy += System.Convert.ToSingle(System.Math.Round(System.Math.Cos((theta +90) *System.Math.PI /180)) *0.001 *speed);
}
if(dir=="up")
{
tempz += System.Convert.ToSingle(0.001 *speed);
}
if(dir=="down")
{
tempz -= System.Convert.ToSingle(0.001 *speed);
}
blockpoint blockmove = gamemanager.checkmove(speed, foundmap.x +tempx, foundmap.y +tempy, foundmap.z +tempz);
if(blockmove==null)
{
orgx = tempx;
orgy = tempy;
orgz = tempz;
updatemove(speed);
return;
}
}
public void matchship(string matchname)
{
if(gamemanager.foundship!=null&&gamemanager.foundship.GetComponent<ship>().shipname==matchname)
{
return;
}
GameObject foundship = gamemanager.GetComponent<manager>().findship(matchname);
if(gamemanager.GetComponent<manager>().foundship!=null&&gamemanager.GetComponent<manager>().foundship!=foundship)
{
gamemanager.GetComponent<manager>().foundship.GetComponent<ship>().source.Stop();
}
gamemanager.GetComponent<manager>().foundship = foundship;
if(foundship.GetComponent<ship>().saveenginesound!="")
{
foundship.GetComponent<ship>().source.Play();
}
}
public int checkstate(string statename)
{
foreach(string a in states)
{
if(a==statename)
{
return 1;
}
}
return 0;
}
public void addstate(string statename)
{
states.Add(statename);
}
public void removestate(string statename)
{
List<string> removestates = new List<string>();
foreach(string a in states)
{
if(a==statename)
{
removestates.Add(a);
}
}
foreach(string a in removestates)
{
states.Remove(a);
}
}
public string checkstatetext(string statename)
{
foreach(string a in states)
{
if(a.Split(" ")[0]==statename)
{
return a.Replace(statename+" ", "");
}
}
return "";
}
public void vacuum()
{
maincamera.GetComponent<AudioLowPassFilter>().enabled = true;
reverbzone.GetComponent<AudioReverbZone>().enabled = false;
}
public void devacuum()
{
maincamera.GetComponent<AudioLowPassFilter>().enabled = false;
reverbzone.GetComponent<AudioReverbZone>().enabled = true;
}
private void OnDestroy()
{
GameObject.Destroy(reverbzone);
}
public int checkforlocation()
{
foreach(location a in globals.locations)
{
if(a.mapname!=location&&luaf.getdistance(transform.position.x, transform.position.z, transform.position.y, a.x, a.y, a.z)<=2)
{
return 1;
}
}
return 0;
}
public void setpos(float x, float y, float z)
{
transform.position = new Vector3(x, z, y);
reverbzone.transform.position = new Vector3(x, z, y);
}
public void updatemove(float speed)
{
List<location> curlocations = new List<location>();
foreach(location a in globals.locations)
{
if(a.name!=location)
{
curlocations.Add(a);
}
}
foreach(location a in curlocations)
{
if(a.name!=location&&System.Convert.ToInt64(foundmap.x +orgx)>=a.x&&System.Convert.ToInt64(foundmap.x +orgx)<=a.maxx&&System.Convert.ToInt64(foundmap.y +orgy)>=a.y&&System.Convert.ToInt64(foundmap.y +orgy)<=a.maxy&&System.Convert.ToInt64(foundmap.z +orgz)>=a.z&&System.Convert.ToInt64(foundmap.z +orgz)<=a.maxz)
{
location = a.name;
foundmap = gamemanager.findmap(a.name);
setuproom(foundmap);
float setorgx = 0f;
float setorgy = 0f;
float setorgz = 0f;
if(a.x!=a.maxx)
{
setorgx = gamemanager.movedistance(System.Convert.ToInt64(a.x), System.Convert.ToInt64(x));
}
if(a.y!=a.maxy)
{
setorgy = gamemanager.movedistance(System.Convert.ToInt64(a.y), System.Convert.ToInt64(y));
}
if(a.z!=a.maxz)
{
setorgz = gamemanager.movedistance(System.Convert.ToInt64(a.z), System.Convert.ToInt64(z));
}
orgx = gamemanager.movedistance(foundmap.x, a.x) +setorgx;
orgy = gamemanager.movedistance(foundmap.y, a.y) +setorgy;
orgz = gamemanager.movedistance(foundmap.z, a.z +setorgz);
foreach(GameObject m in gamemanager.ships)
{
foreach(map y in m.GetComponent<ship>().maps)
{
if(y.name==a.name)
{
matchship(m.GetComponent<ship>().shipname);
}
}
}
break;
}
}
List<runscript> currunscripts = new List<runscript>();
foreach(runscript a in globals.runscripts)
{
currunscripts.Add(a);
}
foreach(runscript a in currunscripts)
{
if(System.Convert.ToInt64(foundmap.x +orgx)>=a.x&&System.Convert.ToInt64(foundmap.x +orgx)<=a.maxx&&System.Convert.ToInt64(foundmap.y +orgy)>=a.y&&System.Convert.ToInt64(foundmap.y +orgy)<=a.maxy&&System.Convert.ToInt64(foundmap.z +orgz)>=a.z&&System.Convert.ToInt64(foundmap.z +orgz)<=a.maxz)
{
gamemanager.runscript(a.script, a.mapname);
}
}
}
public void setuproom(map foundmap)
{
string sound = gamemanager.GetComponent<mapfunctions>().checkstatetext(foundmap, "sound");
AudioClip foundsound = null;
if(sound!="")
{
foundsound = gamemanager.GetComponent<manager>().findsound(sound);
if(gamemanager.GetComponent<manager>().roomsound!=sound)
{
gamemanager.GetComponent<manager>().roomsound = sound;
gamemanager.GetComponent<manager>().roomsource.Stop();
if(foundsound==null&&sound!="")
{
foundsound = gamemanager.GetComponent<manager>().loadsound(sound, true);
foundsound.name = sound;
globals.sounds.Add(foundsound);
}
if(foundsound!=null)
{
gamemanager.GetComponent<manager>().roomsource.clip = foundsound;
gamemanager.GetComponent<manager>().roomsource.Play();
}
}
}
gamemanager.GetComponent<manager>().setupzone(gameObject.GetComponent<PlayerController>(), gamemanager.GetComponent<mapfunctions>().checkstatetext(foundmap, "env"));
loadsteps(gamemanager.GetComponent<mapfunctions>().checkstatetext(foundmap, "steptype"));
}
}
public class luafunctions : MonoBehaviour
{
public float todoublefloat(double num)
{
return System.Convert.ToSingle(num);
}
public void luadebug(string debugmsg)
{
Debug.Log(debugmsg);
}
public long toint(long num)
{
return System.Convert.ToInt64(num);
}
public long tointstr(string num)
{
return System.Convert.ToInt64(num);
}
public long tointdouble(double num)
{
return System.Convert.ToInt64(num);
}
public string str(long newstring)
{
return Convert.ToString(newstring);
}
public float getdistance(float x, float y, float z, float destx, float desty, float destz)
{
return Vector3.Distance(new Vector3(x, y, z), new Vector3(destx, desty, destz));
}
public float random(float min, float max)
{
return UnityEngine.Random.Range(min, max);
}
public long toint(float num)
{
return System.Convert.ToInt64(num);
}
public ship getactiveship()
{
return GameObject.Find("Game Manager").GetComponent<manager>().foundship.GetComponent<ship>();
}
public double todouble(string num)
{
return System.Convert.ToDouble(num);
}
public float tofloatstr(string num)
{
return System.Convert.ToSingle(num);
}
public string tostrfloat(float num)
{
return System.Convert.ToString(num);
}
public void say(string text)
{
#if UNITY_STANDALONE_WIN
SendToTolk(text);
#elif UNITY_STANDALONE_LINUX
SendToSpd(text);
#elif UNITY_STANDALONE_OSX
SendToMactalk(text);
#elif UNITY_ANDROID
SendToAndroidTts(text);
#endif
}
private void SendToAndroidTts(string text)
{
var uplayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
var curactivity = uplayer.GetStatic<AndroidJavaObject>("currentActivity");
var tts = new AndroidJavaObject("android.speech.tts.TextToSpeech", curactivity, null);
tts.Call<int>("speak", text, 0, null, "Soverign Engine game");
}
private void SendToMactalk(string text)
{
string newtext = "\"'{"+text+"}'\"";
System.Diagnostics.ProcessStartInfo startinfo = new System.Diagnostics.ProcessStartInfo() {FileName = "/usr/bin/say",Arguments = $" "+newtext,};
System.Diagnostics.Process proc = new System.Diagnostics.Process() {
StartInfo = startinfo,};
proc.Start();
}
private void SendToTolk(string text)
{
Tolk.Output(text, true);
}
private void SendToSpd(string text)
{
string newtext = "\"'{"+text+"}'\"";
System.Diagnostics.ProcessStartInfo startinfo = new System.Diagnostics.ProcessStartInfo() {FileName = "/usr/bin/spd-say",Arguments = $"-o "+globals.outputmodule+" -y "+globals.outputvoice+" -r "+globals.outputrate+" -p "+globals.outputpitch+" -i "+globals.outputvolume+" "+newtext,};
System.Diagnostics.Process proc = new System.Diagnostics.Process() {
StartInfo = startinfo,};
proc.Start();
}
}
public class misc : MonoBehaviour
{
public float orientx = 0f;
public float orienty = 0f;
public float orientz = 0f;
public List<string> states;
public int damage = 0;
public int maxdamage = 0;
public float orgx = 0f;
public float orgy = 0f;
public float orgz = 0f;
public string mapname = "";
public blockpoint block;
public float mapx = 0f;
public float mapy = 0f;
public float mapz = 0f;
private float neworgx = 0f;
private float neworgy = 0f;
private float neworgz = 0f;
public map foundmap;
private void Awake()
{
states = new List<string>();
}
private void Start()
{
foundmap = GameObject.Find("Game Manager").GetComponent<manager>().findmap(mapname);
}
public int checkstate(string statename)
{
foreach(string a in states)
{
if(a==statename)
{
return 1;
}
}
return 0;
}
public void addstate(string statename)
{
states.Add(statename);
}
public void removestate(string statename)
{
List<string> removestates = new List<string>();
foreach(string a in states)
{
if(a==statename)
{
removestates.Add(a);
}
}
foreach(string a in removestates)
{
states.Remove(a);
}
}
public string checkstatetext(string statename)
{
foreach(string a in states)
{
if(a.Split(" ")[0]==statename)
{
return a.Replace(statename+" ", "");
}
}
return "";
}
private void LateUpdate()
{
if(foundmap!=null)
{
mapx = foundmap.x;
mapy = foundmap.y;
mapz = foundmap.z;
neworgz = mapz +orgz;
neworgx = mapx +orgx;
neworgy = mapy +orgy;
transform.position = new Vector3(neworgx, neworgz, neworgy);
transform.rotation = Quaternion.Euler(orientx, orienty, orientz);
}
if(block!=null)
{
block.x = transform.position.x;
block.z = transform.position.y;
block.y = transform.position.z;
}
}
}
public class location
{
public string name = "";
public float orgx = 0f;
public float orgy = 0f;
public float orgz = 0f;
public float orgmaxx = 0f;
public float orgmaxy = 0f;
public float orgmaxz = 0f;
public float x = 0f;
public float y = 0f;
public float z = 0f;
public float maxx = 0f;
public float maxy = 0f;
public float maxz = 0f;
public string mapname = "";
}
public class luaupdatefunction
{
public string mapname = "";
public string script = "";
public string name = "";
public Lua lua;
public LuaFunction luafunction;
}
public class map
{
public List<string> states;
public string filename = "";
public string location = "";
public int loaded = 0;
public List<location> locations;
public List<runscript> runscripts;
public map orgmap;
public string name = "";
public List<GameObject> mapobjects;
public float loadx = 0f;
public float loady = 0f;
public float loadz = 0f;
public float loadmaxx = 0f;
public float loadmaxy = 0f;
public float loadmaxz = 0f;
public float x = 0f;
public float y = 0f;
public float z = 0f;
public float movex = 0f;
public float movey = 0f;
public float movez = 0f;
public map()
{
this.states = new List<string>();
this.locations = new List<location>();
this.runscripts = new List<runscript>();
this.mapobjects = new List<GameObject>();
}
}
public class runscript
{
public float orgx = 0f;
public float orgy = 0f;
public float orgz = 0f;
public float orgmaxx = 0f;
public float orgmaxy = 0f;
public float orgmaxz = 0f;
public float x = 0f;
public float y = 0f;
public float z = 0f;
public float maxx = 0f;
public float maxy = 0f;
public float maxz = 0f;
public string script = "";
public string mapname = "";
}
public class setting
{
public string name = "";
public string value = "";
}

public static class globals
{
public static string initdir;
public static List<Mesh> models;
public static string outputvolume;
public static string outputrate;
public static string outputpitch;
public static string outputmodule;
public static string outputvoice;
public static List<string> states;
public static List<Texture2D> textures;
public static List<location> locations;
public static List<map> maps;
public static List<setting> settings;
public static Material skybox;
public static string result;
public static List<luaupdatefunction> addscripts;
public static List<luaupdatefunction> removescripts;
public static List<runscript> runscripts;
public static List<GameObject> mapobjects;
public static List<AudioClip> sounds;
public static int curplayer = 0;
public static List<luaupdatefunction> updatefunctions;
public static server server1;
public static List<blockpoint> blockpoints;
public static List<GameObject> players;
}
public class blockpoint
{
public misc obj;
public int active = 1;
public float x = 0f;
public float y = 0f;
public float z = 0f;
}
public class manager : MonoBehaviour
{
public string roomsound;
public AudioSource roomsource;
public GameObject foundship;
public List<GameObject> ships;
public List<string> getstates()
{
return globals.states;
}
public blockpoint checkmove(float speed, float tempx, float tempy, float tempz)
{
luafunctions luaf = gameObject.GetComponent<luafunctions>();
foreach(blockpoint a in globals.blockpoints)
{
if(luaf.getdistance(tempx, tempy, tempz, a.x, a.y, a.z)<=0.67 +(0.001 *speed))
{
return a;
}
}
return null;
}
public List<luaupdatefunction> getfunctions()
{
return globals.updatefunctions;
}
public string[] splitstr(string text, string splitstr)
{
return text.Split(splitstr);
}
public void removeplayer(string playername)
{
GameObject remplayer = null;
foreach(GameObject a in globals.players)
{
PlayerController plr = a.GetComponent<PlayerController>();
if(plr.playername==playername)
{
remplayer = a;
break;
}
}
if(remplayer!=null)
{
foreach(luaupdatefunction a in globals.updatefunctions)
{
if(a.lua["player"]==remplayer.GetComponent<PlayerController>())
{
removefunction(a);
}
}
if(System.IO.File.Exists(globals.initdir+"/../characters/"+remplayer.GetComponent<PlayerController>().filename)==true)
{
System.IO.File.Delete(globals.initdir+"/../characters/"+remplayer.GetComponent<PlayerController>().filename);
}
globals.players.Remove(remplayer);
GameObject.Destroy(remplayer);
}
}
public PlayerController createplayer()
{
GameObject newplayer = Instantiate(new GameObject(), new Vector3(0f, 0f, 0f), Quaternion.identity);
newplayer.AddComponent<PlayerController>();
globals.players.Add(newplayer);
return newplayer.GetComponent<PlayerController>();
}
void OnEnable()
{
Application.logMessageReceived += plog;
}
void OnDisable()
{
Application.logMessageReceived -= plog;
}
private void Awake()
{
#if UNITY_ANDROID
globals.initdir = Application.persistentDataPath;
#else
globals.initdir = Application.dataPath;
#endif
#if UNITY_STANDALONE_WIN
Tolk.Load();
#endif
gameObject.AddComponent<SoundManager>();
gameObject.AddComponent<mapfunctions>();
gameObject.AddComponent<luafunctions>();
roomsource = gameObject.AddComponent<AudioSource>();
roomsource.loop = true;
if(System.IO.File.Exists(globals.initdir+"/../plog.log"))
{
System.IO.File.Delete(globals.initdir+"/../plog.log");
}
}
public void setambientlight(float r, float g, float b, float a)
{
RenderSettings.ambientLight = new Color(r, g, b, a);
}
public void setambientintensity(float intensity)
{
RenderSettings.ambientIntensity = intensity;
}
public void setgroundcolor(float r, float g, float b, float a)
{
RenderSettings.ambientGroundColor = new Color(r, g, b, a);
}
public void setskycolor(float r, float g, float b, float a)
{
RenderSettings.ambientSkyColor = new Color(r, g, b, a);
}
public void setequatorcolor(float r, float g, float b, float a)
{
RenderSettings.ambientEquatorColor = new Color(r, g, b, a);
}
private void Start()
{
RenderSettings.ambientIntensity = 0f;
RenderSettings.ambientSkyColor = new Color(0f, 0f, 0f, 1);
RenderSettings.ambientGroundColor = new Color(0f, 0f, 0f, 1);
RenderSettings.ambientEquatorColor = new Color(0f, 0f, 0f, 1f);
RenderSettings.ambientLight = new Color(0.3f, 0.3f, 0.3f, 1f);
globals.models = new List<Mesh>();
globals.states = new List<string>();
globals.sounds = new List<AudioClip>();
globals.textures = new List<Texture2D>();
globals.locations = new List<location>();
globals.maps = new List<map>();
globals.settings = new List<setting>();
globals.addscripts = new List<luaupdatefunction>();
globals.removescripts = new List<luaupdatefunction>();
globals.runscripts = new List<runscript>();
globals.mapobjects = new List<GameObject>();
Physics.simulationMode = SimulationMode.Script;
globals.updatefunctions = new List<luaupdatefunction>();
globals.blockpoints = new List<blockpoint>();
globals.players = new List<GameObject>();
ships = new List<GameObject>();
loadsettings();
loadships();
loadstates();
GameObject watcher = Instantiate(new GameObject(), new Vector3(0f, 0f, 0f), Quaternion.identity);
watcher.AddComponent<PlayerController>();
watcher.GetComponent<PlayerController>().reverbzone.GetComponent<AudioReverbZone>().enabled = false;
watcher.GetComponent<PlayerController>().playername = "The Watcher";
watcher.GetComponent<PlayerController>().location = "maps/galaxy/galaxy.lua";
globals.players.Add(watcher);
setupplayer();
runscript(getsetting("startscript"), "");
}
public map spawnmap(string name, float x, float y, float z, float loadx, float loady, float loadz, float loadmaxx, float loadmaxy, float loadmaxz, string location)
{
map newmap = new map();
newmap.name = name;
newmap.movex = x;
newmap.movey = y;
newmap.movez = z;
newmap.loadx = loadx;
newmap.loady = loady;
newmap.loadz = loadz;
newmap.loadmaxx = loadmaxx;
newmap.loadmaxy = loadmaxy;
newmap.loadmaxz = loadmaxz;
newmap.location = location;
globals.maps.Add(newmap);
return newmap;
}
public void loadship(string filename)
{
string file = System.IO.File.ReadAllText(globals.initdir+"/../"+filename);
string[] filestr = file.Split('\n');
List<map> shipmaps = new List<map>();
string shipdir = "";
float shipdesiredspeed = 0f;
float shipacc = 100f;
List<string> states = new List<string>();
double shipgalx = 0f;
double shipgaly = 0f;
double shipgalz = 0f;
float shipx = 0f;
float shipy = 0f;
float shipz = 0f;
string shiplocation = "";
string shipname = "";
float maxspeed = 0f;
float shipspeed = 0f;
float shippower = 0f;
float shipdesiredpower = 0f;
float shippitch = 0f;
string enginesound = "";
for(int a=0; a<filestr.Length; ++a)
{
filestr[a] = filestr[a].Replace("\r", "").Replace("\n", "");
}
for(int m=0; m<filestr.Length; ++m)
{
if(filestr[m].Length>=8&&filestr[m].Substring(0, 7)=="shipmap")
{
map foundmap = findmap(filestr[m].Substring(8).Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, ""));
if(foundmap==null)
{
map map1 = loadmap(filestr[m].Substring(8).Replace(System.Environment.NewLine, "").Replace(".lua", ".map"));
foundmap = map1;
}
shipmaps.Add(foundmap);
}
if(filestr[m].Length>=8&&filestr[m].Substring(0, 7)=="shipdir")
{
shipdir = filestr[m].Substring(8).Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, "");
}
if(filestr[m].Length>=16&&filestr[m].Substring(0, 16)=="shipdesiredspeed")
{
shipdesiredspeed = System.Convert.ToSingle(filestr[m].Substring(17));
}
if(filestr[m].Length>=10&&filestr[m].Substring(0, 10)=="shipaccell")
{
shipacc = System.Convert.ToSingle(filestr[m].Substring(11));
}
if(filestr[m].Length>=9&&filestr[m].Substring(0, 9)=="shippower")
{
shippower = System.Convert.ToSingle(filestr[m].Substring(10));
}
if(filestr[m].Length>=16&&filestr[m].Substring(0, 16)=="shipdesiredpower")
{
shipdesiredpower = System.Convert.ToSingle(filestr[m].Substring(17));
}
if(filestr[m].Length>=9&&filestr[m].Substring(0, 9)=="shipspeed")
{
shipspeed = System.Convert.ToSingle(filestr[m].Substring(10));
}
if(filestr[m].Length>=9&&filestr[m].Substring(0, 9)=="shippitch")
{
shippitch = System.Convert.ToSingle(filestr[m].Substring(10));
}
if(filestr[m].Length>=8&&filestr[m].Substring(0, 8)=="shipname")
{
shipname = filestr[m].Substring(9).Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, "");
}
if(filestr[m].Length>=15&&filestr[m].Substring(0, 15)=="shipenginesound")
{
enginesound = filestr[m].Substring(16).Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, "");
}
if(filestr[m].Length>=12&&filestr[m].Substring(0, 12)=="shipmaxspeed")
{
maxspeed = float.Parse(filestr[m].Substring(13));
}
if(filestr[m].Length>=9&&filestr[m].Substring(0, 9)=="shipstate")
{
states.Add(filestr[m].Substring(10).Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, ""));
}
if(filestr[m].Length>=8&&filestr[m].Substring(0, 8)=="shipgalx")
{
shipgalx = System.Convert.ToDouble(filestr[m].Substring(9));
}
if(filestr[m].Length>=8&&filestr[m].Substring(0, 8)=="shipgaly")
{
shipgaly = System.Convert.ToDouble(filestr[m].Substring(9));
}
if(filestr[m].Length>=8&&filestr[m].Substring(0, 8)=="shipgalz")
{
shipgalz = System.Convert.ToDouble(filestr[m].Substring(9));
}
if(filestr[m].Length>=5&&filestr[m].Substring(0, 5)=="shipx")
{
shipx = System.Convert.ToSingle(filestr[m].Substring(6));
}
if(filestr[m].Length>=5&&filestr[m].Substring(0, 5)=="shipy")
{
shipy = System.Convert.ToSingle(filestr[m].Substring(6));
}
if(filestr[m].Length>=5&&filestr[m].Substring(0, 5)=="shipz")
{
shipz = System.Convert.ToSingle(filestr[m].Substring(6));
}
if(filestr[m].Length>=12&&filestr[m].Substring(0, 12)=="shiplocation")
{
shiplocation = filestr[m].Substring(13).Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, "");
}
}
GameObject ship1 = Instantiate(new GameObject(), new Vector3(0f, 0f, 0f), Quaternion.identity);
ship1.name = shipname;
ship1.AddComponent<ship>();
ship shipscript = ship1.GetComponent<ship>();
shipscript.maps = shipmaps;
shipscript.dir = shipdir;
shipscript.states = states;
shipscript.acc = shipacc;
shipscript.power = shippower;
shipscript.desiredpower = shipdesiredpower;
shipscript.desiredspeed = shipdesiredspeed;
shipscript.speed = shipspeed;
shipscript.pitch = shippitch;
shipscript.saveable = 1;
shipscript.shipname = shipname;
shipscript.maxspeed = maxspeed;
shipscript.galx = shipgalx;
shipscript.galy = shipgaly;
shipscript.galz = shipgalz;
shipscript.shipx = shipx;
shipscript.shipy = shipy;
shipscript.shipz = shipz;
shipscript.location = shiplocation;
if(enginesound!="")
{
shipscript.saveenginesound = enginesound;
}
ship1.GetComponent<ship>().setupsounds();
ships.Add(ship1);
}
public GameObject findship(string shipname)
{
foreach(GameObject a in ships)
{
if(a.GetComponent<ship>().shipname==shipname)
{
return a;
}
}
return null;
}
public void loadstates()
{
string file = System.IO.File.ReadAllText(globals.initdir+"/../states");
string[] filestr = file.Split("\n");
foreach(string a in filestr)
{
globals.states.Add(a.Replace("\r", "").Replace("\n", ""));
}
}
public void savestates()
{
if(System.IO.File.Exists(globals.initdir+"/../states")==true)
{
System.IO.File.Delete(globals.initdir+"/../states");
}
var newfile = System.IO.File.CreateText(globals.initdir+"/../states");
foreach(string a in globals.states)
{
if(a!="")
{
newfile.WriteLine(a);
}
}
newfile.Flush();
newfile.Close();
}
public void saveships()
{
foreach(GameObject a in ships)
{
ship shipscript = a.GetComponent<ship>();
if(shipscript.saveable==1)
{
var newfile = System.IO.File.CreateText(globals.initdir+"/../vehicles and objects/"+shipscript.shipname+".ship");
newfile.WriteLine("shipname "+shipscript.shipname);
newfile.WriteLine("shipdir "+shipscript.dir);
newfile.WriteLine("shipaccell "+shipscript.acc);
newfile.WriteLine("shipgalx "+shipscript.galx);
newfile.WriteLine("shipgaly "+shipscript.galy);
newfile.WriteLine("shipgalz "+shipscript.galz);
newfile.WriteLine("shipx "+shipscript.shipx);
newfile.WriteLine("shipy "+shipscript.shipy);
newfile.WriteLine("shipz "+shipscript.shipz);
newfile.WriteLine("shiplocation "+shipscript.location);
newfile.WriteLine("shipmaxspeed "+System.Convert.ToString(shipscript.maxspeed));
newfile.WriteLine("shipspeed "+System.Convert.ToString(shipscript.speed));
newfile.WriteLine("shipdesiredspeed "+System.Convert.ToString(shipscript.desiredspeed));
newfile.WriteLine("shipenginesound "+shipscript.saveenginesound);
newfile.WriteLine("shippower "+System.Convert.ToString(shipscript.power));
newfile.WriteLine("shipdesiredpower "+System.Convert.ToString(shipscript.desiredpower));
if(shipscript.source!=null)
{
newfile.WriteLine("shippitch "+System.Convert.ToString(shipscript.pitch));
}
foreach(map m in shipscript.maps)
{
if(m!=null&&m.name!=""&&gameObject.GetComponent<mapfunctions>().checkstate(m, "dontsave")==0)
{
newfile.WriteLine("shipmap "+m.name);
}
}
foreach(string m in shipscript.states)
{
newfile.WriteLine("shipstate "+m);
}
newfile.Flush();
newfile.Close();
}
}
}
private void Update()
{
for(int a=0; a<globals.players.Count; ++a)
{
if(globals.players[a]!=globals.players[globals.curplayer]&&globals.players[a].GetComponent<PlayerController>().reverbzone.GetComponent<AudioReverbZone>().enabled==true)
{
globals.players[a].GetComponent<PlayerController>().reverbzone.GetComponent<AudioReverbZone>().enabled = false;
}
}
foreach(luaupdatefunction a in globals.addscripts)
{
if(a!=null&&a.lua!=null)
{
int foundscript = 0;
foreach(luaupdatefunction m in globals.updatefunctions)
{
if(m.name==a.name&&m.mapname==a.mapname&&m.script==a.script)
{
foundscript = 1;
}
}
if(foundscript==0)
{
globals.updatefunctions.Add(a);
}
}
}
globals.addscripts.Clear();
foreach(luaupdatefunction a in globals.updatefunctions)
{
if(a!=null&&a.luafunction!=null)
{
a.luafunction.Call();
}
}
foreach(luaupdatefunction a in globals.removescripts)
{
if(a!=null)
{
if(a.lua!=null)
{
a.lua.Dispose();
a.lua = null;
}
}
globals.updatefunctions.Remove(a);
}
globals.removescripts.Clear();
}
private void setupshiplists(GameObject ship1)
{
ship shipscript = ship1.GetComponent<ship>();
shipscript.states = new List<string>();
}
public AudioClip loadsound(string soundfile, bool streaming=false)
{
if(soundfile=="")
{
return null;
}
UnityWebRequest clipdata = UnityWebRequestMultimedia.GetAudioClip("file://"+globals.initdir+"/../"+soundfile, AudioType.OGGVORBIS);
if(streaming==true)
{
DownloadHandlerAudioClip cliphandle = (DownloadHandlerAudioClip)clipdata.downloadHandler;
cliphandle.streamAudio = true;
}
clipdata.SendWebRequest();
while(clipdata.isDone==false)
{
}
AudioClip clip = DownloadHandlerAudioClip.GetContent(clipdata);
return clip;
}
public Texture2D loadtexture(string texturefile)
{
foreach(Texture2D a in globals.textures)
{
if(a.name==texturefile)
{
return a;
}
}
Texture2D newtex = new Texture2D(3840, 2160);
byte[] texdata = System.IO.File.ReadAllBytes(globals.initdir+"/../"+texturefile);
newtex.LoadImage(texdata);
newtex.wrapMode = TextureWrapMode.Repeat;
newtex.Apply(true, true);
newtex.name = texturefile;
globals.textures.Add(newtex);
return newtex;
}
public float getdeltatime()
{
return Time.deltaTime;
}
public void addfunction(string scriptname, string functionname, string mapname="", PlayerController player=null)
{
if(player==null)
{
player = globals.players[globals.curplayer].GetComponent<PlayerController>();
}
luaupdatefunction luaintp = new luaupdatefunction();
luaintp.lua = new Lua();
luaintp.mapname = mapname;
luaintp.name = functionname;
luaintp.script = scriptname;
luaintp.lua["updatefunction"] = luaintp;
luaintp.lua["mapname"] = mapname;
luaintp.lua["player"] = player;
luaintp.lua["manager"] = GetComponent<manager>();
luaintp.lua["sound"] = gameObject.GetComponent<SoundManager>();
luaintp.lua["luafunctions"] = gameObject.GetComponent<luafunctions>();
luaintp.lua["mapfunctions"] = GetComponent<mapfunctions>();
luaintp.lua.DoFile(globals.initdir+"/../"+scriptname);
LuaFunction newupdatescript = luaintp.lua[functionname] as LuaFunction;
luaintp.luafunction = newupdatescript;
globals.addscripts.Add(luaintp);
}
public void runscript(string scriptname, string mapname)
{
map usemap = findmap(scriptname);
if(usemap!=null)
{
usemap.loaded = 1;
}
Lua newlua = new Lua();
newlua["mapname"] = mapname;
if(globals.players.Count>=globals.curplayer)
{
newlua["player"] = globals.players[globals.curplayer].GetComponent<PlayerController>();
}
newlua["manager"] = GetComponent<manager>();
newlua["sound"] = gameObject.GetComponent<SoundManager>();
newlua["luafunctions"] = gameObject.GetComponent<luafunctions>();
newlua["mapfunctions"] = GetComponent<mapfunctions>();
newlua.DoFile(globals.initdir+"/../"+scriptname);
newlua.Dispose();
newlua = null;
}
public float movedistance(double startcoord, double destcoord, int transdistance=0)
{
float transport2 = 0f;
if(System.Convert.ToInt64(startcoord)==System.Convert.ToInt64(destcoord))
{
return 0;
}
float transport = 0f;
if(startcoord>destcoord)
{
for(double a=destcoord; a<startcoord; ++a)
{
transport -= 1;
transport2 += 1;
}
}
else
{
for(double a=startcoord; a<destcoord; ++a)
{
transport += 1;
transport2 += 1;
}
}
if(startcoord==destcoord)
{
transport = 0f;
}
if(transdistance==0)
{
return transport;
}
else
{
return transport2;
}
}
private void eventloop()
{
globals.server1.netmanager.PollEvents();
foreach(string a in globals.server1.messages)
{
}
globals.server1.messages.Clear();
}
public Vector2 checkinputmovement(InputAction moveaction)
{
Vector2 returnvector = moveaction.ReadValue<Vector2>();
return returnvector;
}
public InputAction addinputaction()
{
return new InputAction(type:InputActionType.Button);
}
public ship getshipscript(GameObject newship)
{
return newship.GetComponent<ship>();
}
public Vector3 movethetadistance(float startx, float starty, float startz, float addx, float addy, float addz, float theta)
{
float destx = startx;
float desty = starty;
float destz = startz;
for(float a=startx; a<startx +movedistance(startx, addx); ++a)
{
destx += System.Convert.ToSingle(System.Math.Sin(theta *System.Math.PI /180));
}
for(float a=starty; a<starty +movedistance(starty, addy); ++a)
{
desty += System.Convert.ToSingle(System.Math.Cos(theta *System.Math.PI /180));
}
Vector3 returnvector = new Vector3(destx, desty, destz);
return returnvector;
}
public PlayerController findplayer(string pname)
{
foreach(GameObject a in globals.players)
{
if(a.GetComponent<PlayerController>().playername==pname)
{
return a.GetComponent<PlayerController>();
}
}
return null;
}
public int checkmainplayer(PlayerController newplayer)
{
if(globals.players.Count==0||globals.curplayer>globals.players.Count)
{
return 0;
}
if(globals.players[globals.curplayer]==newplayer.gameObject)
{
return 1;
}
return 0;
}
public luaupdatefunction findluafunction(string scriptname, string fname, string mapname = "")
{
foreach(luaupdatefunction a in globals.updatefunctions)
{
if(a.mapname==mapname&&a.script==scriptname&&a.name==fname)
{
return a;
}
}
return null;
}
public void removefunction(luaupdatefunction updatefunction)
{
globals.removescripts.Add(updatefunction);
}
public int checkstateplayers(string statename)
{
foreach(GameObject a in globals.players)
{
foreach(string m in a.GetComponent<PlayerController>().states)
{
if(m==statename)
{
return 1;
}
}
}
return 0;
}
public string builddirlist(string dir, string removestring="")
{
List<string> dirs = new List<string>();
string[] listdirs = System.IO.Directory.GetDirectories(globals.initdir+"/../"+dir);
string add = "";
foreach(string a in listdirs)
{
string[] dir2 = a.Split("/");
dirs.Add(dir2[dir2.Length -1]);
}
foreach(string a in dirs)
{
string adddir = a;
adddir = adddir.Replace(dir, "");
if(removestring!="")
{
adddir = adddir.Replace(removestring, "");
}
adddir = adddir.Replace("\\", "");
add += adddir;
if(a!=dirs[dirs.Count -1])
{
add += "|";
}
}
return add;
}
public string buildfilelist(string dir, string removestring = "")
{
List<string> files = new List<string>();
string[] filelist = System.IO.Directory.GetFiles(globals.initdir+"/../"+dir);
string add = "";
foreach(string a in filelist)
{
string[] file = a.Split("/");
files.Add(file[file.Length -1]);
}
foreach(string a in files)
{
string addfile = a;
addfile = addfile.Replace("\\", "");
addfile = addfile.Replace(dir, "");
if(removestring!="")
{
addfile = addfile.Replace(removestring, "");
}
if(a!=files[files.Count -1])
{
addfile += "|";
}
add += addfile;
}
return add;
}
public string readfile(string file)
{
return System.IO.File.ReadAllText(globals.initdir+"/../"+file);
}
public server checkserver()
{
return globals.server1;
}
public List<string> buildstringlist(string text)
{
List<string> buildstr = new List<string>();
string[] str = text.Split("|");
foreach(string a in str)
{
buildstr.Add(a);
}
return buildstr;
}
public string randomstringfromlist(List<string> pick)
{
return pick[new System.Random().Next(0, pick.Count)];
}
public string buildstringfromlist(List<string> stringslist)
{
string buildstr = "";
foreach(string a in stringslist)
{
if(a!=stringslist[stringslist.Count -1])
{
buildstr += a+"|";
}
else
{
buildstr += a;
}
}
return buildstr;
}
public int findnumlist(List<GameObject> destlist, GameObject destobj)
{
for(int a=0; a<destlist.Count; ++a)
{
if(destlist[a]==destobj)
{
return a;
}
}
return -1;
}
public List<PlayerController> getplayerlist()
{
List<PlayerController> listplayers = new List<PlayerController>();
foreach(GameObject a in globals.players)
{
listplayers.Add(a.GetComponent<PlayerController>());
}
return listplayers;
}
public void exit()
{
Application.Quit();
}
public int getmonth()
{
return DateTime.Now.Month;
}
public int getfps()
{
    // Adding 0.5f ensures it rounds to the nearest whole number
    return (int)((1f / Time.unscaledDeltaTime) + 0.5f);
}
public void setplayernum(int playernum)
{
globals.players[globals.curplayer].GetComponent<PlayerController>().reverbzone.GetComponent<AudioReverbZone>().enabled = false;
globals.curplayer = playernum;
globals.players[globals.curplayer].GetComponent<PlayerController>().reverbzone.GetComponent<AudioReverbZone>().enabled = true;
}
public void changeskybox(Material skybox)
{
RenderSettings.skybox = skybox;
globals.skybox = skybox;
}
public AudioClip findsound(string sound)
{
foreach(AudioClip a in globals.sounds)
{
if(a.name==sound)
{
return a;
}
}
return null;
}
public void hidegame()
{
foreach(GameObject a in globals.mapobjects)
{
if(a.GetComponent<MeshRenderer>()!=null)
{
a.GetComponent<MeshRenderer>().enabled = false;
}
if(a.GetComponent<Light>()!=null)
{
a.GetComponent<Light>().enabled = false;
}
}
}
public void showgame()
{
foreach(GameObject a in globals.mapobjects)
{
if(a.GetComponent<MeshRenderer>()!=null)
{
a.GetComponent<MeshRenderer>().enabled = true;
}
if(a.GetComponent<Light>()!=null)
{
a.GetComponent<Light>().enabled = true;
}
}
}
public void changeres(int resx, int resy, int fullscreen)
{
if(fullscreen==0)
{
Screen.SetResolution(resx, resy, false);
}
else
{
Screen.SetResolution(resx, resy, true);
}
}
public void setcamerarange(int range)
{
GameObject.Find("Main Camera").GetComponent<Camera>().farClipPlane = range;
}
public void setupzone(PlayerController plr, string roomenv)
{
AudioReverbZone zone = plr.reverbzone.GetComponent<AudioReverbZone>();
zone.minDistance = 1;
zone.maxDistance = 100;
if(roomenv=="sewer_pipe")
{
zone.reverbPreset = AudioReverbPreset.SewerPipe;
}
if(roomenv=="stone_corridor")
{
zone.reverbPreset = AudioReverbPreset.StoneCorridor;
}
if(roomenv=="hangar")
{
zone.reverbPreset = AudioReverbPreset.Hangar;
}
if(roomenv=="hallway")
{
zone.reverbPreset = AudioReverbPreset.Hallway;
}
if(roomenv=="cave")
{
zone.reverbPreset = AudioReverbPreset.Cave;
}
if(roomenv=="auditorium")
{
zone.reverbPreset = AudioReverbPreset.Auditorium;
}
if(roomenv=="concert_hall")
{
zone.reverbPreset = AudioReverbPreset.Concerthall;
}
if(roomenv=="arena")
{
zone.reverbPreset = AudioReverbPreset.Arena;
}
if(roomenv=="dizzy")
{
zone.reverbPreset = AudioReverbPreset.Dizzy;
}
if(roomenv=="drugged")
{
zone.reverbPreset = AudioReverbPreset.Drugged;
}
if(roomenv=="generic")
{
zone.reverbPreset = AudioReverbPreset.Generic;
}
if(roomenv=="padded_sell")
{
zone.reverbPreset = AudioReverbPreset.PaddedCell;
}
if(roomenv=="bathroom")
{
zone.reverbPreset = AudioReverbPreset.Bathroom;
}
if(roomenv=="room")
{
zone.reverbPreset = AudioReverbPreset.Room;
}
if(roomenv=="livingroom")
{
zone.reverbPreset = AudioReverbPreset.Livingroom;
}
if(roomenv=="stone_room")
{
zone.reverbPreset = AudioReverbPreset.Stoneroom;
}
if(roomenv=="carpetted_hallway")
{
zone.reverbPreset = AudioReverbPreset.CarpetedHallway;
}
if(roomenv=="alley")
{
zone.reverbPreset = AudioReverbPreset.Alley;
}
if(roomenv=="forrest")
{
zone.reverbPreset = AudioReverbPreset.Forest;
}
if(roomenv=="city")
{
zone.reverbPreset = AudioReverbPreset.City;
}
if(roomenv=="mountains")
{
zone.reverbPreset = AudioReverbPreset.Mountains;
}
if(roomenv=="quarry")
{
zone.reverbPreset = AudioReverbPreset.Quarry;
}
if(roomenv=="plain")
{
zone.reverbPreset = AudioReverbPreset.Plain;
}
if(roomenv=="parkinglot")
{
zone.reverbPreset = AudioReverbPreset.ParkingLot;
}
if(roomenv=="underwater")
{
zone.reverbPreset = AudioReverbPreset.Underwater;
}
if(roomenv=="psychotic")
{
zone.reverbPreset = AudioReverbPreset.Psychotic;
}
}
public List<GameObject> getships()
{
return ships;
}
public void setupplayer()
{
List<string> characters = buildstringlist(buildfilelist("characters", ""));
for(int a=0; a<characters.Count; ++a)
{
GameObject player = Instantiate(new GameObject(), new Vector3(1f, 1f, 1f), Quaternion.identity);
globals.players.Add(player);
player.AddComponent<PlayerController>();
if(globals.curplayer!=a)
{
player.GetComponent<PlayerController>().reverbzone.GetComponent<AudioReverbZone>().enabled = false;
}
player.GetComponent<PlayerController>().load(characters[a]);
}
Resources.UnloadUnusedAssets();
System.GC.Collect();
}
public void movecamera(float x, float y, float z, int lerp=0)
{
if(lerp==0)
{
GameObject.Find("Main Camera").transform.position = new Vector3(x, z, y);
}
else
{
GameObject maincamera = GameObject.Find("Main Camera");
Vector3 setpos = new Vector3(Mathf.Lerp(maincamera.transform.position.x, x, 5f *Time.deltaTime), Mathf.Lerp(maincamera.transform.position.y, z, 5f *Time.deltaTime), Mathf.Lerp(maincamera.transform.position.z, y, 5f *Time.deltaTime));
maincamera.transform.position = setpos;
}
}
public void takeinput(Char result)
{
globals.result = System.Convert.ToString(result);
}
public void enableinput()
{
Keyboard.current.onTextInput += takeinput;
}
public void disableinput()
{
Keyboard.current.onTextInput -= takeinput;
}
public string getresult()
{
return globals.result;
}
public void cleargetresult()
{
globals.result = "";
}
public void hidecursor()
{
Cursor.visible = false;
}
public void showcursor()
{
Cursor.visible = true;
}
public void setquality(int qlevel, bool change)
{
QualitySettings.SetQualityLevel(qlevel, change);
QualitySettings.pixelLightCount = 64;
QualitySettings.anisotropicFiltering = AnisotropicFiltering.Enable;
QualitySettings.globalTextureMipmapLimit = 0;
}
public void setvsync(int vsync)
{
QualitySettings.vSyncCount = vsync;
}
public void setframerate(int fps)
{
Application.targetFrameRate = fps;
}
public List<string> buildlistfromstring(string str, string splitstr)
{
List<string> returnstr = new List<string>();
string[] newstr = str.Split(splitstr);
foreach(string a in newstr)
{
if(a!="")
{
returnstr.Add(a);
}
}
return returnstr;
}
public void orientcamera(float orientx, float orienty, float orientz)
{
GameObject.Find("Main Camera").transform.rotation = Quaternion.Euler(orientx, orienty, orientz);
}
public Material getskybox()
{
return globals.skybox;
}
public double sin(double value)
{
return System.Math.Sin(value);
}
public double cos(double value)
{
return System.Math.Cos(value);
}
public double round(double num)
{
return System.Math.Round(num);
}
public double getpi()
{
return System.Math.PI;
}
public Vector3 getcamerapos()
{
return GameObject.Find("Main Camera").transform.position;
}
public void loadsettings()
{
string file = System.IO.File.ReadAllText(globals.initdir+"/../settings.lst");
string[] filestr = file.Split("\n");
for(int a=0; a<filestr.Length; ++a)
{
filestr[a] = filestr[a].Replace("\r", "").Replace("\n", "");
}
foreach(string a in filestr)
{
if(a!=""&&a!=System.Environment.NewLine)
{
setting newsetting = new setting();
newsetting.name = a.Split("|")[0].Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, "");
newsetting.value = a.Split("|")[1].Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, "");
globals.settings.Add(newsetting);
}
}
}
public string getsetting(string settingname)
{
foreach(setting a in globals.settings)
{
if(a.name==settingname)
{
return a.value;
}
}
return "";
}
public int setsetting(string settingname, string value)
{
foreach(setting a in globals.settings)
{
if(a.name==settingname)
{
a.value = value;
return 1;
}
}
return 0;
}
public void addsetting(string settingname, string settingvalue)
{
setting newsetting = new setting();
newsetting.name = settingname;
newsetting.value = settingvalue;
globals.settings.Add(newsetting);
}
public void unloadmap(string mapname)
{
map removemap = null;
foreach(map a in globals.maps)
{
if(a.name==mapname)
{
removemap = a;
foreach(GameObject m in a.mapobjects)
{
if(m!=null)
{
globals.mapobjects.Remove(m);
if(m.GetComponent<misc>()!=null&&m.GetComponent<misc>().block!=null)
{
globals.blockpoints.Remove(m.GetComponent<misc>().block);
}
GameObject.Destroy(m);
}
}
a.mapobjects.Clear();
foreach(runscript m in a.runscripts)
{
globals.runscripts.Remove(m);
}
a.runscripts.Clear();
foreach(location m in removemap.locations)
{
globals.locations.Remove(m);
}
a.locations.Clear();
removemap.loaded = 0;
}
}
}
public void loadships()
{
List<string> files = buildlistfromstring(buildfilelist("vehicles and objects", "vehicles and objects"), "|");
foreach(string a in files)
{
loadship("vehicles and objects/"+a);
}
}
public void removemap(map newmap)
{
unloadmap(newmap.name);
globals.maps.Remove(newmap);
}
public void addmaptoship(map newmap, ship addship)
{
addship.maps.Add(newmap);
}
public void removeshipmap(ship remship, map remmap)
{
if(remmap==null||remship==null)
{
return;
}
remship.maps.Remove(remmap);
}
public Mesh loadmodel(string filename)
{
Mesh newmesh = new Mesh();
newmesh.name = filename;
string path = System.IO.Path.Combine(globals.initdir, "..", filename);
string[] filestr = System.IO.File.ReadAllLines(path);
List<Vector3> vertices = new List<Vector3>();
List<Vector2> uvs = new List<Vector2>();
List<int> triangles = new List<int>();
foreach(string a in filestr)
{
string line = a.Trim();
if (line.Length < 3) continue;
string[] parts = line.Split(new[] { ' ' }, System.StringSplitOptions.RemoveEmptyEntries);
if (parts[0] == "v")
{
vertices.Add(new Vector3(System.Convert.ToSingle(parts[1]), System.Convert.ToSingle(parts[2]), System.Convert.ToSingle(parts[3])));
}
else if (parts[0] == "vt")
{
uvs.Add(new Vector2(System.Convert.ToSingle(parts[1]), System.Convert.ToSingle(parts[2])));
}
else if (parts[0] == "f") // Face Assembly
{
    // The "Sovereign" Fan Triangulation:
    // We take the first vertex as the 'Anchor' (index 1)
    // Then we connect it to every subsequent pair (i and i+1)
    // This turns a 4-point Quad into two 3-point Triangles.
    for (int i = 2; i < parts.Length - 1; i++)
    {
        // Point 1: The Anchor
        string[] p1 = parts[1].Split('/');
        triangles.Add(System.Convert.ToInt32(p1[0]) - 1);

        // Point 2: The Previous
        string[] p2 = parts[i].Split('/');
        triangles.Add(System.Convert.ToInt32(p2[0]) - 1);

        // Point 3: The Current
        string[] p3 = parts[i + 1].Split('/');
        triangles.Add(System.Convert.ToInt32(p3[0]) - 1);
    }
}
}
while(uvs.Count<vertices.Count)
{
uvs.Add(new Vector2(00f, 0f));
}
newmesh.SetVertices(vertices);
newmesh.SetUVs(0, uvs);
newmesh.SetTriangles(triangles, 0);
newmesh.RecalculateNormals();
newmesh.RecalculateBounds();
Vector3 center = newmesh.bounds.center;
Vector3[] verts = newmesh.vertices;
for (int i = 0; i < verts.Length; i++)
{
verts[i] -= center; // This "Flushes" the offset out of the data
}
newmesh.vertices = verts;
newmesh.RecalculateBounds(); // Re-measure the truth
globals.models.Add(newmesh);
return newmesh;
}
public map loadmap(string filename)
{
map newmap = new map();
newmap.filename = filename;
string file = System.IO.File.ReadAllText(globals.initdir+"/../"+filename);
string[] filestr = file.Split("\n");
for(int a=0; a<filestr.Length; ++a)
{
filestr[a] = filestr[a].Replace("\r", "").Replace("\n", "");
}
foreach(string a in filestr)
{
if(a.Length>=8&&a.Substring(0, 7)=="mapname")
{
newmap.name = a.Substring(8).Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, "");
}
if(a.Length>=9&&a.Substring(0, 8)=="mapstate")
{
newmap.states.Add(a.Substring(9).Replace(System.Environment.NewLine, ""));
}
if(a.Length>=9&&a.Substring(0, 8)=="maploadx")
{
newmap.loadx = System.Convert.ToSingle(a.Substring(9));
}
if(a.Length>=9&&a.Substring(0, 8)=="maploady")
{
newmap.loady = System.Convert.ToSingle(a.Substring(9));
}
if(a.Length>=9&&a.Substring(0, 8)=="maploadz")
{
newmap.loadz = System.Convert.ToSingle(a.Substring(9));
}
if(a.Length>=12&&a.Substring(0, 11)=="maploadmaxx")
{
newmap.loadmaxx = System.Convert.ToSingle(a.Substring(12));
}
if(a.Length>=12&&a.Substring(0, 11)=="maploadmaxy")
{
newmap.loadmaxy = System.Convert.ToSingle(a.Substring(12));
}
if(a.Length>=12&&a.Substring(0, 11)=="maploadmaxz")
{
newmap.loadmaxz = System.Convert.ToSingle(a.Substring(12));
}
if(a.Length>=5&&a.Substring(0, 4)=="mapx")
{
newmap.movex = System.Convert.ToSingle(a.Substring(5));
}
if(a.Length>=5&&a.Substring(0, 4)=="mapy")
{
newmap.movey = System.Convert.ToSingle(a.Substring(5));
}
if(a.Length>=5&&a.Substring(0, 4)=="mapz")
{
newmap.movez = System.Convert.ToSingle(a.Substring(5));
}
if(a.Length>=12&&a.Substring(0, 11)=="maplocation")
{
newmap.location = a.Substring(12).Replace("\n", "").Replace("\r", "").Replace("\r\n", "").Replace(System.Environment.NewLine, "");
}
}
newmap.x = newmap.movex;
newmap.y = newmap.movey;
newmap.z = newmap.movez;
globals.maps.Add(newmap);
return newmap;
}
public map findmap(string mapname)
{
foreach(map a in globals.maps)
{
if(a.name==mapname||a.filename==mapname)
{
return a;
}
}
return null;
}
public void movemap(map newmap, float x, float y, float z)
{
newmap.x = x;
newmap.y = y;
newmap.z = z;
foreach(location a in newmap.locations)
{
float neworgx = newmap.x +a.orgx;
float neworgy = newmap.y +a.orgy;
float neworgmaxx = newmap.x +a.orgmaxx;
float neworgmaxy = newmap.y +a.orgmaxy;
float neworgz = newmap.z +a.orgz;
float neworgmaxz = newmap.z +a.orgmaxz;
a.x = neworgx;
a.y = neworgy;
a.z = neworgz;
a.maxx = neworgmaxx;
a.maxy = neworgmaxy;
a.maxz = neworgmaxz;
}
foreach(runscript a in newmap.runscripts)
{
float neworgx = newmap.x +a.orgx;
float neworgy = newmap.y +a.orgy;
float neworgmaxx = newmap.x +a.orgmaxx;
float neworgmaxy = newmap.y +a.orgmaxy;
float neworgz = newmap.z +a.orgz;
float neworgmaxz = newmap.z +a.orgmaxz;
a.x = neworgx;
a.y = neworgy;
a.z = neworgz;
a.maxx = neworgmaxx;
a.maxy = neworgmaxy;
a.maxz = neworgmaxz;
}
}
public List<map> getmaps()
{
return globals.maps;
}
public void setcamerafov(int fov)
{
GameObject.Find("Main Camera").GetComponent<Camera>().fieldOfView = fov;
}
public void savemaps()
{
foreach(map a in globals.maps)
{
if(a.name!=""&&a.name!=".lua"&&a.filename!=""&&a.filename!=".map"&&gameObject.GetComponent<mapfunctions>().checkstate(a, "nofile")==0)
{
savemap(a);
}
}
}
public void savemap(map a)
{
if(System.IO.File.Exists(globals.initdir+"/../"+a.filename))
{
System.IO.File.Delete(globals.initdir+"/../"+a.filename);
}
var file = System.IO.File.CreateText(globals.initdir+"/../"+a.filename);
file.WriteLine("mapname "+a.name);
file.WriteLine("maplocation "+a.location);
file.WriteLine("mapx "+a.movex);
file.WriteLine("mapy "+a.movey);
file.WriteLine("mapz "+a.movez);
file.WriteLine("maploadx "+a.loadx);
file.WriteLine("maploady "+a.loady);
file.WriteLine("maploadz "+a.loadz);
file.WriteLine("maploadmaxx "+a.loadmaxx);
file.WriteLine("maploadmaxy "+a.loadmaxy);
file.WriteLine("maploadmaxz "+a.loadmaxz);
foreach(string m in a.states)
{
file.WriteLine("mapstate "+m);
}
file.Flush();
file.Close();
}
public void plog(string logString, string stackTrace, LogType type)
{
System.IO.File.AppendAllText(globals.initdir+"/../plog.log", logString+"\r\n");
}
public void disablecamera()
{
GameObject.Find("Main Camera").GetComponent<Camera>().enabled = false;
}
public void enablecamera()
{
GameObject.Find("Main Camera").GetComponent<Camera>().enabled = true;
}
public ship findshipbymap(string location)
{
foreach(GameObject a in ships)
{
ship shipscript = a.GetComponent<ship>();
foreach(map m in shipscript.maps)
{
if(m.name==location||m.filename==location)
{
return shipscript;
}
}
}
return null;
}
public void cleanup()
{
System.GC.Collect();
Resources.UnloadUnusedAssets();
}
public string replacestring(string newstr, string replacetext, string replacetext2)
{
return newstr.Replace(replacetext, replacetext2);
}
public string getline()
{
return System.Environment.NewLine;
}
public void savesettings()
{
if(System.IO.File.Exists(globals.initdir+"/../settings.lst")==true)
{
System.IO.File.Delete(globals.initdir+"/../settings.lst");
}
var newfile = System.IO.File.CreateText(globals.initdir+"/../settings.lst");
foreach(setting a in globals.settings)
{
newfile.WriteLine(a.name+"|"+a.value);
}
newfile.Flush();
newfile.Close();
}
public void reloadfunctions()
{
foreach(luaupdatefunction a in globals.updatefunctions)
{
int inlist = 0;
foreach(luaupdatefunction m in globals.removescripts)
{
if(m==a)
{
inlist = 1;
}
}
foreach(luaupdatefunction m in globals.addscripts)
{
if(m==a)
{
inlist = 1;
}
}
if(inlist==0)
{
removefunction(a);
addfunction(a.script, a.name, a.mapname);
}
}
}
public List<GameObject> spawnlist()
{
return new List<GameObject>();
}
public List<string> spawnstringlist()
{
return new List<string>();
}
public Material addmaterial(string shader)
{
Material newmat = new Material(Shader.Find(shader));
newmat.EnableKeyword("_Emission");
return newmat;
}
public void settexture(Material mat, string tex, Texture2D settex)
{
mat.SetTexture(tex, settex);
}
public void setdynamictiling(Material materialToModify, float x, float y)
{
materialToModify.mainTextureScale = new Vector2(x, y);
if (materialToModify.mainTexture != null)
{
materialToModify.mainTexture.wrapMode = TextureWrapMode.Repeat;
}
}
public void setproperty(Material mat, string prop, float setvalue)
{
mat.SetFloat(prop, setvalue);
}
public void setvector3(Material mat, string setvec, float x, float y, float z)
{
mat.SetVector(setvec, new Vector3(x, z, y));
}
public void setvector2(Material mat, string setvec, float x, float y)
{
mat.SetVector(setvec, new Vector2(x, y));
}
public void setcolor(Material mat, string colorset, float r, float g, float b, float a)
{
mat.SetColor(colorset, new Color(r, g, b, a));
}
public Material loadmaterial(string matfile)
{
if(System.IO.File.Exists(globals.initdir+"/../"+matfile)==false)
{
return null;
}
string[] matstr = System.IO.File.ReadAllText(globals.initdir+"/../"+matfile).Split('\n');
if(matstr.Length<=1)
{
return null;
}
for(int a=0; a<matstr.Length; ++a)
{
matstr[a] = matstr[a].Replace("\r", "").Replace("\n", "");
}
Material mat = addmaterial(matstr[0].Replace(System.Environment.NewLine, ""));
for(int a=1; a<matstr.Length; ++a)
{
string texstr = matstr[a].Replace(System.Environment.NewLine, "");
if(texstr=="tile")
{
setdynamictiling(mat, System.Convert.ToSingle(matstr[a +1]), System.Convert.ToSingle(matstr[a +2]));
}
if(texstr=="property")
{
setproperty(mat, matstr[a +1].Replace("\n", ""), System.Convert.ToSingle(matstr[a +2]));
}
if(texstr=="vector3")
{
setvector3(mat, matstr[a +1], System.Convert.ToSingle(matstr[a +2]), System.Convert.ToSingle(matstr[a +3]), System.Convert.ToSingle(matstr[a +4]));
}
if(texstr=="vector2")
{
setvector2(mat, matstr[a +1], System.Convert.ToSingle(matstr[a +2]), System.Convert.ToSingle(matstr[a +3]));
}
if(texstr=="color")
{
setcolor(mat, matstr[a +1].Replace("\n", ""), System.Convert.ToSingle(matstr[a +2]), System.Convert.ToSingle(matstr[a +3]), System.Convert.ToSingle(matstr[a +4]), System.Convert.ToSingle(matstr[a +5]));
}
if(texstr=="texture")
{
settexture(mat, matstr[a +1].Replace("\n", ""), loadtexture(matstr[a +2].Replace("\n", "")));
}
}
return mat;
}
public string checkstatetext(string statename)
{
foreach(string a in globals.states)
{
if(a.Split(" ")[0]==statename)
{
return a.Replace(statename+" ", "");
}
}
return "";
}
public void addstate(string statename)
{
globals.states.Add(statename);
}
public void removestate(string statename)
{
List<String> removestates = new List<string>();
foreach(string a in globals.states)
{
if(a==statename)
{
removestates.Add(a);
}
}
foreach(string a in removestates)
{
globals.states.Remove(a);
}
}
public int checkstate(string statename)
{
foreach(string a in globals.states)
{
if(a==statename)
{
return 1;
}
}
return 0;
}
public void setspeech(string module, string voice, string rate, string pitch, string volume)
{
globals.outputmodule = module;
globals.outputrate = rate;
globals.outputpitch = pitch;
globals.outputvolume = volume;
globals.outputvoice = voice;
}
}
