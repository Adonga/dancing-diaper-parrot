using UnityEngine;
using System.Collections;

public class CGameSingelton : Singelton<CGameSingelton>
{
    public bool alive;
    public CGameState currentGameState;
    public CGameState previousGameState;
    public Vector3 cameraPosition;
    public Vector3 cameraAngle;
	// Use this for initialization
	void Start () {
        GameObject.DontDestroyOnLoad(this.gameObject);
        cameraAngle = this.transform.localEulerAngles;
        cameraAngle.x = 20;
        this.transform.localEulerAngles = cameraAngle;
        cameraPosition = this.transform.localEulerAngles;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
