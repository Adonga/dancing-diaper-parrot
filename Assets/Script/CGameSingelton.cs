using UnityEngine;
using System.Collections;

public class CGameSingelton : Singelton<CGameSingelton>
{
    public bool alive;
    public bool inGame;
    public int egg;
    public CGameState currentGameState;
    public CGameState previousGameState;
    public Vector3 destinatinPosition;
    public Vector3 cameraPosition;
    public Vector3 cameraAngle;
    public Vector3 playerPosition = CPlayer.position;
    public float x;
    public bool win;
    public GameObject[] mEnemy;
	// Use this for initialization
	void Start () {
        GameObject.DontDestroyOnLoad(this.gameObject);
        cameraAngle = this.transform.localEulerAngles;
       // cameraAngle.x = 40;
       // cameraAngle.y = 40;
      //  this.transform.localEulerAngles = cameraAngle;
        this.transform.localPosition =  playerPosition - new Vector3(13 , -5, 12) ;
       // cameraPosition = this.transform.localPosition;
        inGame = false;
	}
	
	// Update is called once per frame
	void Update () {
        if (win)
        {
            win = false;
            egg = 0;
            Application.LoadLevel("MainMenu");
        }
        //computeCameraPosition();
	}

    /*void computeCameraPosition() 
    {
        if (CPlayer.underGround)
        {
            cameraPosition.y = 6;
        }
        //first get where from player one is
        playerPosition = CPlayer.position;
        cameraPosition = playerPosition - new Vector3(13, -20, 12);
        this.transform.localPosition = cameraPosition;
       // rotateCamera();
    }
    void rotateCamera()
    {
        float sin = Mathf.Sin(x +Mathf.PI / 2);
        float cos = Mathf.Cos(x + Mathf.PI / 2);
        if (Input.GetKey(KeyCode.Q))
        {
            cameraPosition.x = (int)playerPosition.x + 20 * sin;
            cameraPosition.z = (int)playerPosition.z + 20 * cos;
 
            x += 0.05f;
        }
        else if (Input.GetKey(KeyCode.E))
        {
            cameraPosition.x = (int)playerPosition.x + 20 * sin;
            cameraPosition.z = (int)playerPosition.z + 20 * cos;

            x -= 0.05f;
        }
    //   else
     //   {
      //      cameraPosition.x = playerPosition.x + sin;
      //      cameraPosition.z = playerPosition.z + cos;
      //  }
     //   this.transform.LookAt(playerPosition);
            
        cameraPosition.y = 5;
        
        this.transform.localPosition = cameraPosition;
    }*/

}