using UnityEngine;
using System.Collections;

public class CEnemy : MonoBehaviour {

	// Use this for initialization
    public bool alive = true;
    public Vector3 position;
    Vector3 direction;
    int time;
	void Start () {
        position = this.transform.localPosition;
	}
	
	// Update is called once per frame
	void FixedUpdate () {

        direction = CGameSingelton.instance.destinatinPosition- this.transform.localPosition;
        direction.y = 0;
       // direction = new Vector3(Random.value - 0.5f, 0, Random.value - 0.5f);
        direction.Normalize();

        this.transform.localPosition += direction * 0.1f;

        time++; 
	}
    void OnCollisionEnter(Collision coll) 
    {
        if(coll.gameObject.tag =="Player" )
        {
            alive = false;
            DestroyObject(gameObject);
        }
        if (coll.gameObject.tag == "Destination") 
        {
            DestroyObject(gameObject);
        }
    }

    void OnTriggerEnter(Collider coll)
    {
        if (coll.gameObject.tag == "Player")
        {
  //          Debug.Log("AAAAAHHHHHH!!11!!");
        }
    }
    void OnTriggerStay(Collider coll)
    {
        if (coll.gameObject.tag == "Player")
        {
      //      Debug.Log("AAAAAHHHHHH!!11!!");
        }
    }
}
