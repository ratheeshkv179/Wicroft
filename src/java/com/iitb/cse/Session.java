package com.iitb.cse;

import java.net.ServerSocket;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.Calendar;
import lombok.Getter;
import lombok.Setter;


/**
 *
 * @author sanchitgarg
 * This class is used for holding information for a session.
 * 
 */
public class Session {
    
        @Getter @Setter String userName = null;
        @Getter @Setter int userId;
        
        /*
            Selected clients based on selected bssid by an user
        */
        @Getter @Setter   ConcurrentHashMap<String, DeviceInfo> selectedConnectedClients = new ConcurrentHashMap<String, DeviceInfo>();
        /*
            selected bssids by an user
        */
        @Getter @Setter   ConcurrentHashMap<String, String > selectedBssidInfo = new ConcurrentHashMap<String, String >();
        
        /*
            Set of selected clients for each of the features apchange, sending file, starting experiments etc.
        */
        @Getter @Setter CopyOnWriteArrayList<String> changeApSelectedClients = new CopyOnWriteArrayList<String>();
        @Getter @Setter CopyOnWriteArrayList<String> sendCtrlFileSelectedClients = new CopyOnWriteArrayList<String>();
        @Getter @Setter CopyOnWriteArrayList<String> sendOldCtrlFileSelectedClients = new CopyOnWriteArrayList<String>();
        @Getter @Setter CopyOnWriteArrayList<String> startExpSelectedClients = new CopyOnWriteArrayList<String>();
        @Getter @Setter CopyOnWriteArrayList<String> wakeUpTimerSelectedClients = new CopyOnWriteArrayList<String>();
        @Getter @Setter CopyOnWriteArrayList<String> appUpdateSelectedClients = new CopyOnWriteArrayList<String>();
        @Getter @Setter CopyOnWriteArrayList<String> requestLogFileSelectedClients = new CopyOnWriteArrayList<String>();
        
        
        @Getter @Setter ConcurrentHashMap<String, String > changeApFilteredClients = new ConcurrentHashMap<String, String >();
        @Getter @Setter ConcurrentHashMap<String, String > sendCtrlFileFilteredClients = new ConcurrentHashMap<String, String >();
        @Getter @Setter ConcurrentHashMap<String, String > sendOldCtrlFileFilteredClients = new ConcurrentHashMap<String, String >();
        @Getter @Setter ConcurrentHashMap<String, String > startExpFilteredClients = new ConcurrentHashMap<String, String >();
        @Getter @Setter ConcurrentHashMap<String, String > wakeUpTimerFilteredClients = new ConcurrentHashMap<String, String >();
        @Getter @Setter ConcurrentHashMap<String, String > appUpdateFilteredClients = new ConcurrentHashMap<String, String >();
        @Getter @Setter ConcurrentHashMap<String, String > requestLogFileFilteredClients = new ConcurrentHashMap<String, String >();
        
        @Getter @Setter ConcurrentHashMap<String, String> controlFileSendingFailedClients = new ConcurrentHashMap<String, String>();
        @Getter @Setter ConcurrentHashMap<String, String> controlFileSendingSuccessClients = new ConcurrentHashMap<String, String>();
        
        @Getter @Setter String  currentControlFileId = "";
        @Getter @Setter String  currentControlFileName = "";
        @Getter @Setter String  lastConductedExpId = "";
        
        /*
            flags to indicate the module is running like  change AP, experiment is running etc.
        */
        @Getter @Setter boolean changeApRunning = false;
        @Getter @Setter boolean sendCtrlFileRunning = false;
        @Getter @Setter boolean sendOldCtrlFileRunning = false;
        @Getter @Setter boolean startExpRunning = false;
        @Getter @Setter boolean wakeUpTimerRunning = false;
        @Getter @Setter boolean appUpdateRunning = false;
        @Getter @Setter boolean reqLogFileRunning = false;
        
        /*
            Variable to keep track of Wake UP timer
        */
        @Getter @Setter long startwakeUpDuration = 0;
        @Getter @Setter long wakeUpDuration = 0;
        @Getter @Setter String  wakeUpFilter = "";
        @Getter @Setter boolean sendingWakeUpRequest = false;
        
        
        @Getter @Setter String currentAction = "";
        @Getter @Setter String wakeupValue;
        
        
	@Getter @Setter Integer sessionID = 1;		//ID of the session
	@Getter @Setter String name;				//name of session
	@Getter @Setter String user;				//username of user holding that session
	@Getter @Setter boolean serverOn = true;	//no use of the variable
        
        @Getter @Setter boolean sendingControlFile = false;
        @Getter @Setter boolean sendingControlFileStatus = false;
        
	@Getter @Setter boolean experimentRunning = false;
        @Getter @Setter boolean wakeUpStatus = false;
        
        @Getter @Setter String retryControlFileId= "";	
        @Getter @Setter String retryControlFileName= "";	
        
        @Getter @Setter boolean fetchingLogFiles = false;
        @Getter @Setter boolean fetchingLogFilesStatus = false;
	@Getter @Setter Experiment curExperiment;
        @Getter @Setter int currentExperimentId = 0;

	@Getter @Setter CopyOnWriteArrayList<DeviceInfo> filteredClients = new CopyOnWriteArrayList<DeviceInfo>();
	@Getter @Setter CopyOnWriteArrayList<DeviceInfo> actualFilteredDevices = new CopyOnWriteArrayList<DeviceInfo>();
        @Getter @Setter CopyOnWriteArrayList<DeviceInfo> apConfFilteredDevices = new CopyOnWriteArrayList<DeviceInfo>();
        @Getter @Setter CopyOnWriteArrayList<DeviceInfo> configFilteredDevices = new CopyOnWriteArrayList<DeviceInfo>();        
        @Getter @Setter ConcurrentHashMap<String, DeviceInfo> getLogFilefFilteredDevices = new ConcurrentHashMap<String, DeviceInfo>();
        
        @Getter @Setter ConcurrentHashMap<String, String> controlFileSendingStatus = new ConcurrentHashMap<String, String>();
        
        @Getter @Setter ConcurrentHashMap<String,String> updateAppClients = new ConcurrentHashMap<String,String>();
        
        @Getter @Setter CopyOnWriteArrayList<DeviceInfo> wakeUpDevices = new CopyOnWriteArrayList<DeviceInfo>();
        
        @Getter @Setter ConcurrentHashMap<String, String> wakeUpDevicesStatus = new ConcurrentHashMap<String, String>();
        
	@Getter @Setter Calendar cal = Calendar.getInstance();
	@Getter @Setter Integer startExpTCounter=0;
	@Getter @Setter Integer stopExpTCounter=0;
	@Getter @Setter Integer clearRegTCounter=0;
	@Getter @Setter Integer refreshTCounter=0;	
        @Getter @Setter Integer logFileSend=0;        
        @Getter @Setter ServerSocket connectionSocket;

	/**
	* constructor
	*/
	public Session(String userName, int userId){
            this.userName = userName;
            this.userId = userId;
	}
 
	/*
	* Decrements the refreshTCounter 
	*/
	public void DecrementRefreshTCounter(){
		refreshTCounter--;
		if(refreshTCounter<=0){
		}
	}
}
