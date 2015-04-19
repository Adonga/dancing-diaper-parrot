using UnityEngine;
using System.Collections;

public class CSpawner : MonoBehaviour {
   public  float mNextSpawnTime;
    public float mSpwanTime = 20;
    
    public Bounds mBounds = new Bounds(new Vector3(0, -10, 2), new Vector3(22, 5, 0));
    

    void Spawner(){
        int i = 0;
        GameObject prefab = CGameSingelton.instance.mEnemy[i];
        
        GameObject instance = GameObject.Instantiate (prefab) as GameObject;

        Vector3 position = mBounds.center + Vector3.Scale(mBounds.size, new Vector3(2.5f * Random.value, 2.5f * Random.value, 2.5f * Random.value)) 
            - mBounds.size * 0.5f;
        
        instance.transform.position = position;
    }
    // Update is called once per frame
    void Update ()
    {
        if (mNextSpawnTime <= 0) {
            //spawn
           // Debug.Log ("Spawn");
            mNextSpawnTime = mSpwanTime;
            Spawner();
        }
        mNextSpawnTime -= Time.deltaTime;
    }
     
}
