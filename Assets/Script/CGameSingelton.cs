using UnityEngine;
using System.Collections;

public class CGameSingelton : Singelton<CGameSingelton>
{
    public bool alive;
    public CGameState currentGameState;
    public CGameState previousGameState;
	// Use this for initialization
	void Start () {
        GameObject.DontDestroyOnLoad(this.gameObject);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
