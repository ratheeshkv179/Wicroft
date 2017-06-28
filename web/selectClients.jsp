<%-- 
    Document   : selectClients
    Created on : 4 Jun, 2017, 11:44:46 AM
    Author     : cse
--%>



<%@page import="java.sql.ResultSet"%>
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page import="java.util.concurrent.CopyOnWriteArrayList"%>
<%@page import="com.iitb.cse.Utils"%>
<%@page import="com.mysql.jdbc.Util"%>
<%@page import="org.eclipse.jdt.internal.compiler.impl.Constant"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@page import="com.iitb.cse.DeviceInfo"%>
<%@page import="com.iitb.cse.*"%>
<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>CrowdSource-ServerHandler</title>

        <!-- Bootstrap Core CSS -->
        <link href="/serverplus/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

        <!-- MetisMenu CSS -->
        <link href="/serverplus/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="/serverplus/dist/css/sb-admin-2.css" rel="stylesheet">

        <!-- Morris Charts CSS -->
        <link href="/serverplus/vendor/morrisjs/morris.css" rel="stylesheet">

        <!-- Custom Fonts -->
        <link href="/serverplus/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

    </head>

    <body>
 <div id="wrapper">

            <!-- Navigation -->
            <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="frontpage.jsp">CrowdSource Application - SERVER</a>
                </div>
                <!-- /.navbar-header -->

                <ul class="nav navbar-top-links navbar-right">

                    <!-- /.dropdown -->
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                            <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-user">

                            <li class="divider"></li>
                            <li>

                                <a href="logout.jsp?logout=logout"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                            </li>
                        </ul>
                        <!-- /.dropdown-user -->
                    </li>
                    <!-- /.dropdown -->
                </ul>
                <!-- /.navbar-top-links -->

              
                <!-- /.navbar-static-side -->
                
                 <div id="links" class="navbar-default sidebar" role="navigation">
                </div>
            </nav>



<%
            
            
        if(session.getAttribute("currentUser")==null){
            response.sendRedirect("login.jsp");
        }else{
//            response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);

           if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{

            CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients(mySession);
            Utils.getSelectedConnectedClients(mySession);
            ResultSet rs = DBManager.getControlFileInfo();  
            ConcurrentHashMap<String, String> apConnection = Utils.getAccessPointConnectionDetails(mySession);
            String module = request.getParameter("module");
            String fileId = request.getParameter("fileid");
            //module = "sendControlFile";

            String event = request.getParameter("closewindow");
            if(event != null && event.equalsIgnoreCase("true")){
                out.write("<script>window.close()</script>");
            }
            System.out.println("WAKE UP");
            
        %>

            <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-9"><br><br><br>

                                    <div class="panel panel-info">
                                    <div class="panel-heading active">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">Select Clients</a>
                                        </h4>
                                    </div>



                                    <!-- <div id="collapseTwo" class="panel-collapse collapse"> -->
                                        <div class="panel-body">
                                         <div class="row">
                                    <div class="col-lg-6">
                                        <form role="form"  action="selectClientsHandler.jsp" method="get" >
                                          <input type="hidden" name="module" value="<%=module%>" />
                                          <input type="hidden" name="fileid" value="<%=fileId%>" />
                                            <div class="form-group">
                                                <!--<label>Selects</label>-->
                                                <select class="form-control" name='filter' id='filter' onchange="_check(this)">
                                                    <option value="none" >--select--</option>
                                                    <option value="bssid" >BSSID</option>
                                                    <option value="ssid" >SSID</option>
                                                    <option value="manual" >Manual</option>
                                                    <option value="random" >Random</option>
                                                </select>
                                            </div>    

                                            <div class="form-group">    
                                                <!--<label>Selects</label>-->
                                                <select class="form-control" name='bssid' id='selectonbssid' style="display: none;width: 300px" multiple size='10'>
                                                    <%  Enumeration<String> _bssidList = Utils.getAllBssids(mySession);
                                                        while (_bssidList.hasMoreElements()) {
                                                            String bssid = _bssidList.nextElement();
                                                            if(bssid != null && bssid.trim().length()>0){
                                                                
                                                            
                                                             String ssid_count = apConnection.get(bssid);
                                                             String info[] = ssid_count.split("#");
                                                    
                                                            out.write("<option value=\"" + bssid + "\">" + bssid +" -- "+ info[0]+"</option>");
                                                            }
                                                        }
                                                    %>
                                                </select>
                                            </div>

                                            <div class="form-group">    
                                                <!--<label>Selects</label>-->
                                                <select class="form-control" name='ssid' id='selectonssid' style="display: none" multiple size='10'>
                                                    <%
                                                        Enumeration<String> _ssidList = Utils.getAllSsids(mySession);
                                                        while (_ssidList.hasMoreElements()) {
                                                            String ssid = _ssidList.nextElement();
                                                            if(ssid != null && ssid.trim().length()>0){
                                                                 out.write("<option value=\"" + ssid + "\">" + ssid + "</option>");
                                                            }
                                                            
                                                           
                                                        }
                                                    %>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <input type="number" id ='random' name='random' value='1' min="1" max="50" style="display: none" />
                                            </div>
                                            
                                             <div class="form-group">
                                                <input type="submit" class="btn btn-default" id='getclient' name='getClients' value="Get_Clients"  style="display: none"/>
                                            </div> 
                                        </form>
                                    </div>
                                </div>
                                        </div>
                                    <!-- </div> -->
                                    </div>


                        <!-- .panel-heading -->
                        
                    
                    
                    
                    
                    
                    
                    <div class="row">
                        <div class="col-lg-12">
                        <form action="selectFilteredClients.jsp" method="get">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <b> Selected Clients Information</b> &emsp; <input type="submit" class="btn btn-danger" style="color:white" name="selectClients" value="Done and Proceed" " >

                                    <input type="hidden" name="module" value="<%=module%>" />

                                </div>
                                <!-- /.panel-heading -->
                                <div class="panel-body">
                                   <table width="100%" class="table table-striped table-bordered table-hover">                                        

                                        <thead>
                                            <tr>
                                                <th>#</th> 
                                                <th>

                                                    Select All<input id="chooseAll"  checked type="checkbox" onchange="selectCheckBox(this);">


                                                </th>
                                                <th>Mac Address</th>
                                                <th>Status</th>
                                                <th>SSID</th>
                                                <th>BSSID</th>
                                                <th>Latest HearBeat</th>
                                                <th>App Version</th>

                                            </tr>
                                        </thead>
                                        <tbody>


                                            <%
    

            CopyOnWriteArrayList<String> selectedMacs = new CopyOnWriteArrayList<String>();

            if(module.equalsIgnoreCase("changeApSettings")){
                selectedMacs = mySession.getChangeApSelectedClients();
            }else if(module.equalsIgnoreCase("sendControlFile")){
                selectedMacs = mySession.getSendCtrlFileSelectedClients();
            }else if(module.equalsIgnoreCase("startExperiment")){
                selectedMacs = mySession.getStartExpSelectedClients();
            }else if(module.equalsIgnoreCase("wakeUpTimer")){
                selectedMacs = mySession.getWakeUpTimerSelectedClients();
            }else if(module.equalsIgnoreCase("appUpdate")){
                selectedMacs = mySession.getAppUpdateSelectedClients();
            }else if(module.equalsIgnoreCase("ReqLogFiles")){
                selectedMacs = mySession.getRequestLogFileSelectedClients();
            }else if(module.equalsIgnoreCase("reUseControlFile")){
                //selectedMacs = mySession.getSendOldCtrlFileSelectedClients();
                selectedMacs = mySession.getSendCtrlFileSelectedClients();

            }

        System.out.println("WAKE UP4 "+selectedMacs);

        if(selectedMacs== null || selectedMacs.size()==0){
            out.write("<tr><td colspan=\"7\">No Clients Selected</td></tr>");
            System.out.println("WAKE UP3");
        }else{
        int count = 0;
        for(int i=0;i<selectedMacs.size();i++){
            count++;
            String mac = selectedMacs.get(i);
            DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);

            if(device == null){
                out.write("<tr><td colspan=\"7\">No Clients Selected</td></tr>");
            }else{
            
            if(activeClient.contains(device)){
                // active
                out.write("<tr><td>"+count+"</td>"
                        + "<td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + device.getMacAddress() + "\"/></td>"
                        + "<td>"+device.getMacAddress()+"</td>"
                        + "<td style='color:green'>Active</td>"
                        + "<td>"+device.getSsid()+"</td>"
                        + "<td>"+device.getBssid()+"</td>"
                        + "<td>"+device.getLastHeartBeatTime()+"</td>"
                        + "<td>"+device.getAppversion()+"</td>"
                        + "</tr>");
            }else{
                // passive
                out.write("<tr><td>"+count+"</td>"
                        + "<td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + device.getMacAddress() + "\"/></td>"
                        + "<td>"+device.getMacAddress()+"</td>"
                        + "<td style='color:red'>Passive</td>"
                        + "<td>"+device.getSsid()+"</td>"
                        + "<td>"+device.getBssid()+"</td>"
                        + "<td>"+device.getLastHeartBeatTime()+"</td>"
                        + "<td>"+device.getAppversion()+"</td>"
                        + "</tr>");
                
            }}
        }
        }
                                                
                                                             
                                                
                                                
                                                
                                                
                                                
                                                
//                                                                   session.setAttribute("filter", null);
//                                                                   session.setAttribute("clientcount", null);
//
//                                                                   if (request.getParameter("getclient") != null) {
//
//                                                                       if (request.getParameter("filter").equals("bssid")) {
//
//                                                                           ConcurrentHashMap<String, DeviceInfo> clients = mySession.getSelectedConnectedClients();
//                                                                           Enumeration<String> macList = clients.keys();
//                                                                           if (clients != null) {
//               //                                                                out.write("<table border='1'>");
//               //                                                                out.write("<tr><th>No</th><th>Select</th><th>Mac Address</th><th>SSID</th><th>BSSID</th><th>Last HeartBeat</th></tr>");
//                                                                               if (clients.size() == 0) {
//                                                                                   out.write("<tr><td colspan=\"7\">No Clients</td></tr>");
//                                                                               } else {
//                                                                                   int i = 0;
//                                                                                   int flag = 0;
//                                                                                   
//                                                                                    ConcurrentHashMap<String, String>  bssidList = new ConcurrentHashMap<String, String>();
//                                                                                   
//                                                                                   String arr[] = request.getParameterValues("bssid");
//                                                                                   for (int p = 0; p < arr.length; p++) {
//                                                                                       //out.write("<br>"+arr[p]+"--"+arr[p].length());
//                                                                                       if(arr[p].length() > 0){
//                                                                                           bssidList.put(arr[p],"1");
//                                                                                       }
//                                                                                    }
//                                                                                   
//                                                                                   
//                                                                                   CopyOnWriteArrayList<String> tempDeviceListMacAddr = new CopyOnWriteArrayList<String>();
//                                                                                   
//                                                                                   while (macList.hasMoreElements()) {
//                                                                                       String macAddr = macList.nextElement();
//                                                                                       DeviceInfo device = clients.get(macAddr);
//
////                                                                                       CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients();
//                                                                                       if (activeClient.contains(device)) {
////                                                                                           if (request.getParameter("bssid").equalsIgnoreCase(device.getBssid())) {
//                                                                                               
//                                                                                           if (bssidList.get(device.getBssid()) != null){
//                                                                                               i++;
//                                                                                               flag = 1;
//                                                                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                           }
//                                                                                       }else{
//                                                                                           //if (request.getParameter("bssid").equalsIgnoreCase(device.getBssid())) {
//                                                                                           if(bssidList.get(device.getBssid()) != null){
//                                                                                               tempDeviceListMacAddr.add(macAddr);                                                                                             
//                                                                                              
//                                                                                           }
//                                                                                       }
//                                                                                   }
//                                                                                   
//                                                                                   
//                                                                                    for (int j = 0; j < tempDeviceListMacAddr.size(); j++) {
//                                                                                        String mac = tempDeviceListMacAddr.get(j);
//                                                                                        DeviceInfo device = clients.get(mac);
//                                                                                        
//                                                                                        i++;
//                                                                                        flag = 1;
//                                                                                        out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                    }
//                                                                                   
//                                                                                   
//                                                                                   
//                                                                                   
//                                                                                   
//                                                                                   if (flag == 0) {
//                                                                                       out.write("<tr><td colspan=\"7\">No Active Client</td></tr>");
//                                                                                   }
//                                                                               }
//               //                                                                out.write("</table>");
//                                                                           }
//                                                                       } else if (request.getParameter("filter").equals("ssid")) {
//
//                                                                           ConcurrentHashMap<String, DeviceInfo> clients = mySession.getSelectedConnectedClients();
//                                                                           Enumeration<String> macList = clients.keys();
//                                                                           if (clients != null) {
//               //                                                                out.write("<table border='1'>");
//               //                                                                out.write("<tr><th>No</th><th>Select</th><th>Mac Address</th><th>SSID</th><th>BSSID</th><th>Last HeartBeat</th></tr>");
//                                                                               if (clients.size() == 0) {
//                                                                                   out.write("<tr><td colspan=\"7\">No Clients</td></tr>");
//                                                                               } else {
//                                                                                   int i = 0;
//                                                                                   int flag = 0;
//                                                                                   
//                                                                                   
//                                                                                   
//                                                                                    ConcurrentHashMap<String, String> ssidList = new ConcurrentHashMap<String, String>();
//                                                                                   
//                                                                                   String arr[] = request.getParameterValues("ssid");
//                                                                                   for (int p = 0; p < arr.length; p++) {
//                                                                                       //out.write("<br>"+arr[p]+"--"+arr[p].length());
//                                                                                       if(arr[p].length() > 0){
//                                                                                           ssidList.put(arr[p],"1");
//                                                                                       }
//                                                                                    }
//                                                                                   
//                                                                                   
//                                                                                   
//                                                                                   CopyOnWriteArrayList<String> tempDeviceListMacAddr = new CopyOnWriteArrayList<String>();
//                                                                                   
//                                                                                   while (macList.hasMoreElements()) {
//                                                                                       String macAddr = macList.nextElement();
//                                                                                       DeviceInfo device = clients.get(macAddr);
////                                                                                       CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients();
//                                                                                       if (activeClient.contains(device)) {
////                                                                                           if (request.getParameter("ssid").equalsIgnoreCase(device.getSsid())) {
//                                                                                           if (ssidList.get(device.getSsid()) != null) {
//                                                                                               i++;
//                                                                                               flag = 1;
//                                                                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                           }
//                                                                                       }else{
//                                                                                           
//                                                                                           //if (request.getParameter("ssid").equalsIgnoreCase(device.getSsid())) {
//                                                                                           if (ssidList.get(device.getSsid()) != null) {
//                                                                                               tempDeviceListMacAddr.add(macAddr);                                                                                             
//                                                                                              
//                                                                                           }
//                                                                                           
//                                                                                       }
//                                                                                   }
//                                                                                   
//                                                                                   
//                                                                                   for (int j = 0; j < tempDeviceListMacAddr.size(); j++) {
//                                                                                        String mac = tempDeviceListMacAddr.get(j);
//                                                                                        DeviceInfo device = clients.get(mac);
//                                                                                        
//                                                                                        i++;
//                                                                                        flag = 1;
//                                                                                        out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                    }
//                                                                                   
//                                                                                   
//                                                                                   
//                                                                                   
//                                                                                   if (flag == 0) {
//                                                                                       out.write("<tr><td colspan=\"7\">No Active Client</td></tr>");
//                                                                                   }
//                                                                               }
//               //                                                                out.write("</table>");
//                                                                           }
//
//                                                                       } else if (request.getParameter("filter").equals("manual")) {
//
//                                                                           ConcurrentHashMap<String, DeviceInfo> clients = mySession.getSelectedConnectedClients();
//                                                                           Enumeration<String> macList = clients.keys();
//                                                                           if (clients != null) {
//               //                                                                out.write("<table border='1'>");
//               //                                                                out.write("<tr><th>No</th><th>Select</th><th>Mac Address</th><th>SSID</th><th>BSSID</th><th>Last HeartBeat</th></tr>");
//                                                                               if (clients.size() == 0) {
//                                                                                   out.write("<tr><td colspan=\"7\">No Clients</td></tr>");
//                                                                               } else {
//                                                                                   int i = 0;
//                                                                                   int flag = 0;
//                                                                                   CopyOnWriteArrayList<String> tempDeviceListMacAddr = new CopyOnWriteArrayList<String>();
//                                                                                   
//                                                                                   while (macList.hasMoreElements()) {
//                                                                                       String macAddr = macList.nextElement();
//                                                                                       DeviceInfo device = clients.get(macAddr);
////                                                                                       CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients();
//                                                                                       if (activeClient.contains(device)) {
//                                                                                           i++;
//                                                                                           flag = 1;
//                                                                                           out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                       }else{
//                                                                                           tempDeviceListMacAddr.add(macAddr);             
//                                                                                               
//                                                                                       }
//                                                                                   }
//                                                                                   
//                                                                                   
//                                                                                   for (int j = 0; j < tempDeviceListMacAddr.size(); j++) {
//                                                                                        String mac = tempDeviceListMacAddr.get(j);
//                                                                                        DeviceInfo device = clients.get(mac);
//                                                                                        
//                                                                                        i++;
//                                                                                        flag = 1;
//                                                                                        out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                    }
//                                                                                   
//                                                                                   
//                                                                                   
//                                                                                   
//                                                                                   if (flag == 0) {
//                                                                                       out.write("<tr><td colspan=\"7\">No Active Client</td></tr>");
//                                                                                   }
//                                                                               }
//               //                                                                out.write("</table>");
//                                                                           }
//
//                                                                       } else if (request.getParameter("filter").equals("random")) {
//               //                        session.setAttribute("filter", "random");
//               //                        session.setAttribute("clientcount", request.getParameter("random"));
//
//                                                                           ConcurrentHashMap<String, DeviceInfo> clients = mySession.getSelectedConnectedClients();
//                                                                           Enumeration<String> macList = clients.keys();
//                                                                           if (clients != null) {
//               //                                                                out.write("<table border='1'>");
//               //                                                                out.write("<tr><th>No</th><th>Select</th><th>Mac Address</th><th>SSID</th><th>BSSID</th><th>Last HeartBeat</th></tr>");
//                                                                               if (clients.size() == 0) {
//                                                                                   out.write("<tr><td colspan=\"7\">No Clients</td></tr>");
//                                                                               } else {
//                                                                                   int i = 0;
//                                                                                   int count = 0;
//                                                                                   int flag = 0;
//                                                                                   
//                                                                                   CopyOnWriteArrayList<String> tempDeviceListMacAddr = new CopyOnWriteArrayList<String>();
//                                                                                    
//                                                                                   while (macList.hasMoreElements()) {
//                                                                                       String macAddr = macList.nextElement();
//                                                                                       DeviceInfo device = clients.get(macAddr);
//
////                                                                                       CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients();
//                                                                                       
//                                                                                       if (activeClient.contains(device)) {
//                                                                                           i++;
//                                                                                           count++;
//                                                                                           flag = 1;
//                                                                                           if (count <= Integer.parseInt(request.getParameter("random"))) {
//                                                                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                           } else {
//                                                                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\"   name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                           }
//                                                                                       }else{
//                                                                                           
//                                                                                           tempDeviceListMacAddr.add(macAddr);  
//                                                                                           
//                                                                                         
//                                                                                       }
//
//                                                                                   }
//                                                                                   
//                                                                                   
//                                                                                   for (int j = 0; j < tempDeviceListMacAddr.size(); j++) {
//                                                                                        String mac = tempDeviceListMacAddr.get(j);
//                                                                                        DeviceInfo device = clients.get(mac);
//                                                                                        
//                                                                                          i++;
//                                                                                           count++;
//                                                                                           flag = 1;
//                                                                                           if (count <= Integer.parseInt(request.getParameter("random"))) {
//                                                                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                           } else {
//                                                                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\"   name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
//                                                                                           } 
//                                                                                    }
//                                                                                   
//                                                                                  
//                                                                                   
//                                                                                   if (flag == 0) {
//                                                                                       out.write("<tr><td colspan=\"7\">No Active Client</td></tr>");
//                                                                                   }
//                                                                               }
//               //                                                                out.write("</table>");
//                                                                           }
//                                                                       }
//
//                                                                       /*mgr = new DBManager();
//                                  rs = DBManager.getClientList(mgr);
//                                  if (rs != null) {
//                                      out.write("<table style=\"overflow-y:auto\"><tr><th></th><th>MAC ADDRESS</th><th>SSID</th><th>BSSID</th></tr>");
//                                      while (rs.next()) {
//                                          out.write("<tr><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + rs.getString(1) + "\"/></td><td>" + rs.getString(1) + "</td><td>" + rs.getString(2) + "</td><td>" + rs.getString(3) + "</td>");
//                                      }
//                                      out.write("</table>");
//                                      out.write("<input type=\"submit\" id=\'addexperiment\' name=\'getclient\' value=\"Add Experiment\" />");
//                                  }
//                                  mgr.closeConnection();
//                                                                        */
//                                                                   }
                                            %>                 




                                        </tbody>
                                    </table>


                                </div>
                                <!-- /.panel-body -->
                            </div>
                            </form>
                            <!-- /.panel -->
                        </div>
                        <!-- /.col-lg-12 -->
                    </div>
                    
                    
                    
                    
                    
                    
                    
             
                </div>
            
            </div>
         </div>
                                            
        <%
            }
        }

        %>
            
            <!-- /#page-wrapper -->

        </div>
        <!-- /#wrapper -->

        <!-- jQuery -->
        <script src="/serverplus/vendor/jquery/jquery.min.js"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="/serverplus/vendor/bootstrap/js/bootstrap.min.js"></script>

        <!-- Metis Menu Plugin JavaScript -->
        <script src="/serverplus/vendor/metisMenu/metisMenu.min.js"></script>

        <!-- Morris Charts JavaScript -->
        <script src="/serverplus/vendor/raphael/raphael.min.js"></script>
        <script src="/serverplus/vendor/morrisjs/morris.min.js"></script>
        <script src="/serverplus/data/morris-data.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/serverplus/dist/js/sb-admin-2.js"></script>
        <!-- DataTables JavaScript -->
        <script src="/serverplus/vendor/datatables/js/jquery.dataTables.min.js"></script>
        <script src="/serverplus/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="/serverplus/vendor/datatables-responsive/dataTables.responsive.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/serverplus/dist/js/sb-admin-2.js"></script>

        <!-- Page-Level Demo Scripts - Tables - Use for reference -->
        <script>
            $(document).ready(function () {
                $('#dataTables-example').DataTable({
                    responsive: true
                });
            });
        </script>

      <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                refresh();

            });
        </script>

 <script>


            function __check() {
//                alert(document.getElementById('OldorNew').value);
                if (document.getElementById('OldorNew').value == "selectNewFile") {
                    document.getElementById('fileName').style.display = 'none';
                    document.getElementById('OldFIleLabel').style.display = 'none';
                } else if (document.getElementById('OldorNew').value == "selectOldFile") {
                    document.getElementById('fileName').style.display = 'block';
                    document.getElementById('OldFIleLabel').style.display = 'block';
                } else if (document.getElementById('OldorNew').value == "chooseFileLater") {
                    document.getElementById('fileName').style.display = 'none';
                    document.getElementById('OldFIleLabel').style.display = 'none';
                } 
            }

            function sendFile(){

                if (document.getElementById('sendFile').value == "sendNewFile") {
                    document.getElementById('chooseOldFileLabel').style.display = 'none';
                    document.getElementById('oldFileId').style.display = 'none';
                    document.getElementById('chooseNewFileLabel').style.display = 'block';
                    document.getElementById('newFileId').style.display = 'block';  

                }else if (document.getElementById('sendFile').value == "sendOldFile") {
                    document.getElementById('chooseOldFileLabel').style.display = 'block';   
                    document.getElementById('oldFileId').style.display = 'block';
                    document.getElementById('chooseNewFileLabel').style.display = 'none';
                    document.getElementById('newFileId').style.display = 'none';  

                }

            }

            function apcheck(){
                //alert(document.getElementById('security').value);

                if(document.getElementById('security').value=='open'){
                    document.getElementById('username').style.display = 'none';
                    document.getElementById('password').style.display = 'none';
                    document.getElementById('uname').style.display = 'none';
                    document.getElementById('pwd').style.display = 'none';
                }else if(document.getElementById('security').value=='wep'){
                    document.getElementById('username').style.display = 'none';
                    document.getElementById('password').style.display = 'block';
                    document.getElementById('uname').style.display = 'none';
                    document.getElementById('pwd').style.display = 'block';
                }else if(document.getElementById('security').value=='wpa-psk'){
                    document.getElementById('username').style.display = 'none';
                    document.getElementById('password').style.display = 'block';
                    document.getElementById('uname').style.display = 'none';
                    document.getElementById('pwd').style.display = 'block';
                }else if(document.getElementById('security').value=='eap'){
                    document.getElementById('username').style.display = 'block';
                    document.getElementById('password').style.display = 'block';
                    document.getElementById('uname').style.display = 'block';
                    document.getElementById('pwd').style.display = 'block';

                }
            }

            function _check() {
                //   alert(document.getElementById('filter').value);
                if (document.getElementById('filter').value == "bssid") {
                    document.getElementById('selectonbssid').style.display = 'block';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('random').style.display = 'none';
                    document.getElementById('getclient').style.display = 'block';
                } else if (document.getElementById('filter').value == "ssid") {
                    document.getElementById('selectonssid').style.display = 'block';
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('random').style.display = 'none';
                    document.getElementById('getclient').style.display = 'block';
                } else if (document.getElementById('filter').value == "manual") {

                    document.getElementById('random').style.display = 'none';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('getclient').style.display = 'block';

                } else if (document.getElementById('filter').value == "random") {
                    document.getElementById('random').style.display = 'block';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('getclient').style.display = 'block';
                } else {
                    document.getElementById('random').style.display = 'none';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('getclient').style.display = 'none';
                }
            }


           function selectCheckBox() {
                if (document.getElementById("chooseAll").checked == true) {
                    var list = document.getElementsByName("selectedclient");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = true;
                    }
                } else {
                    var list = document.getElementsByName("selectedclient");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = false;
                    }
                }
            }

        </script>
        
        
    </body>
</html>