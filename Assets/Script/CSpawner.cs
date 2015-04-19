using UnityEngine;
using System.Collections;

public class CSpawner : MonoBehaviour {

    void makeEnemy()
    {
        GameObject prefab = CGameSingelton.instance.enemy;
        GameObject clone = (GameObject)Instantiate(prefab, new Vector3(0, 0, 0), transform.rotation);
        clone.transform.localScale = new Vector3(1, 1, 1);
    }

    // Use this for initialization
	void Start () {
	    
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
