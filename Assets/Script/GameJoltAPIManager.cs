using UnityEngine;
using System.Collections;

public class GameJoltAPIManager : MonoBehaviour
{
    public int gameID;
    public string privateKey;
    public string userName;
    public string userToken;
    GJAPI GameJoltAPI   ;
    void Awake()
    {
        DontDestroyOnLoad(gameObject);
        gameID = 60912;
        userName = "Adonga";
        userToken = "4a6f2d";
        privateKey = "2465d53c5d34f2505eb38a16e26ad03e";
        GJAPI.Init(gameID, privateKey);
        GJAPIHelper.Users.ShowLogin();
    }
    
    public void ShowTrophie() 
    {
        GJAPIHelper.Trophies.ShowTrophies();
    }
    public void showScore() 
    {
        GJAPIHelper.Scores.ShowLeaderboards();
    }

   public void startGame() 
    {
        Application.LoadLevel("Paul");
    }

   public void Exit() 
   {
       Application.Quit();
   }
}
