using UnityEngine;
using System.Collections;

public class CPlayer : MonoBehaviour {

	// Use this for initialization
   static public Vector3 position = new Vector3(0,0,0);
   bool hit = false;
   bool alive = true;
	void Start () 
    {
        this.transform.localPosition = new Vector3(5,1,5);
        position = this.transform.localPosition;
	}
	
	// Update is called once per frame
	void FixedUpdate () 
    {
        position = this.transform.localPosition;
        move();
	}

    private void move()
    {
        if (Input.GetKey(KeyCode.D))
        {
            position.x += 0.2f;
            this.transform.localPosition = position;
        }
        else if (Input.GetKey(KeyCode.A))
        {
            position.x -= 0.2f;
            this.transform.localPosition = position;
        }
        if (Input.GetKey(KeyCode.W))
        {
            position.z += 0.2f;
            this.transform.localPosition = position;
        }
        else if (Input.GetKey(KeyCode.S))
        {
            position.z -= 0.2f;
            this.transform.localPosition = position;
        }
        //jump
        if (Input.GetKey(KeyCode.Space))
        {
            position.y += 0.2f;
            this.transform.localPosition = position;
        }

    }

    void OnCollisionEnter(Collision coll)
    {
        if (coll.gameObject.tag == "Player" && hit)
        {
//            CGameSingelton.
        }
        else if (coll.gameObject.tag == "Player") 
        {
            alive = false;
        }
    }
}
