using UnityEngine;
using System.Collections;

public class CGameSingelton : Singelton<CGameSingelton>
{
    public bool alive;
    public CGameState currentGameState;
    public CGameState previousGameState;
    public Vector3 cameraPosition;
    public Vector3 cameraAngle;
    public Vector3 playerPosition = CPlayer.position;
	// Use this for initialization
	void Start () {
        GameObject.DontDestroyOnLoad(this.gameObject);
        cameraAngle = this.transform.localEulerAngles;
        cameraAngle.x = 20;
        cameraAngle.y = 20;
        this.transform.localEulerAngles = cameraAngle;
        this.transform.localPosition = new Vector3(5, 10, 5) - playerPosition;
        cameraPosition = this.transform.localPosition;

	}
	
	// Update is called once per frame
	void Update () {
        playerPosition = CPlayer.position;

        cameraPosition = playerPosition - new Vector3( 0 , -5, 12);
        if (CPlayer.underGround)
        {
            cameraPosition.y = 6;
        }
        this.transform.localPosition = cameraPosition;
        rotateCamera();
	}

    void rotateCamera() {
        if (Input.GetKey(KeyCode.Q)) 
        {
            cameraAngle.y += 0.5f;
            this.transform.localEulerAngles = cameraAngle;
            
        }
        if (Input.GetKey(KeyCode.E))
        {
            cameraAngle.y -= 0.5f;
            this.transform.localEulerAngles = cameraAngle;
        }
    }
}