using UnityEngine;
using System.Collections;

public class CPlayer : MonoBehaviour {

	// Use this for initialization
    Vector3 position = new Vector3(0,0,0);
	void Start () 
    {
        position = this.transform.localPosition;
	}
	
	// Update is called once per frame
	void FixedUpdate () 
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
            position.y += 0.2f;
            this.transform.localPosition = position;
        }
        else if (Input.GetKey(KeyCode.S))
        {
            position.y -= 0.2f;
            this.transform.localPosition = position;
        }
        if (Input.GetKey(KeyCode.Q))
        {
            position.z += 0.2f;
            this.transform.localPosition = position;
        }
        else if (Input.GetKey(KeyCode.E))
        {
            position.z -= 0.2f;
            this.transform.localPosition = position;
        }


	}
}
