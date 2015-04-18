using UnityEngine;
using System.Collections;

public class CEnemy : MonoBehaviour {

	// Use this for initialization
    public bool alive = true;
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    void OnCollisionEnter(Collision coll) 
    {
        if(coll.gameObject.tag =="Player" )
        {
            alive = false;
        }
    }

    void OnTriggerEnter(Collider coll)
    {
        if (coll.gameObject.tag == "Player")
        {
            Debug.Log("AAAAAHHHHHH!!11!!");
        }
    }
    void OnTriggerStay(Collider coll)
    {
        if (coll.gameObject.tag == "Player")
        {
            Debug.Log("AAAAAHHHHHH!!11!!");
        }
    }
}
