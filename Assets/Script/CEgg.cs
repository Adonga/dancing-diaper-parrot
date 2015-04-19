using UnityEngine;
using System.Collections;

public class CEgg : MonoBehaviour {

	// Use this for initialization
    void OnCollisionEnter(Collision coll) 
    {
        if (coll.gameObject.tag == "Player")
        {
            CGameSingelton.instance.egg++;
            DestroyObject(gameObject);
        }
    }
}
