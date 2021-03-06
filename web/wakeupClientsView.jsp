<%-- 
    Document   : wakeupClientsView
    Created on : 11 Mar, 2017, 1:46:32 AM
    Author     : ratheeshkv
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

<%@page import="java.util.Date"%>

<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>Wicroft</title>

        <!-- Bootstrap Core CSS -->
        <link href="/wicroft/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

        <!-- MetisMenu CSS -->
        <link href="/wicroft/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="/wicroft/dist/css/sb-admin-2.css" rel="stylesheet">

        <!-- Morris Charts CSS -->
        <link href="/wicroft/vendor/morrisjs/morris.css" rel="stylesheet">

        <!-- Custom Fonts -->
        <link href="/wicroft/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

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
                    <a class="navbar-brand" href="frontpage.jsp">Wicroft Server</a>
                </div>
                <!-- /.navbar-header -->

                <ul class="nav navbar-top-links navbar-right">

                    <!-- /.dropdown -->
                    <li class="dropdown">

                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <%= session.getAttribute("currentUser") %>
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
                
                <div class="sidebar-nav navbar-collapse">
                        <ul class="nav" id="side-menu">
                            
                            <li>
                                <a href="frontpage.jsp"><i class="fa fa-dashboard fa-fw"></i> Dashboard</a>
                            </li>
                            
                            <li>
                                <a href="configExperiment.jsp"><i class="fa fa-dashboard fa-fw"></i> Experiment Configuration</a>
                            </li>
                            
                            <li>
                                <a href="experimentDetails.jsp"><i class="fa fa-table fa-fw"></i> Experiment History</a>
                            </li>
                            
                            <li>
                                <a href="utilities.jsp"><i class="fa fa-dashboard fa-fw"></i> Utilities</a>
                            </li>
                            
                            <li>
                                <a href="details.jsp"><i class="fa fa-dashboard fa-fw"></i> Details</a>
                            </li>
                            
                            <li>
                                <a href="settings.jsp"><i class="fa fa-dashboard fa-fw"></i> Settings</a>
                            </li>

                        </ul>
                    </div>
                    </div>

            </nav>


    <%
            
            
        if(session.getAttribute("currentUser")==null){
            response.sendRedirect("login.jsp");
        }else{
            response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
            
              if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
            CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients(mySession);
        %>
            <div id="page-wrapper">
                <div class="row">
                    <div class="col-lg-12">
                        <%
                            response.setIntHeader("refresh", 1);

                            long time = (mySession.getWakeUpDuration()) - ((System.currentTimeMillis()) -mySession.getStartwakeUpDuration()) / 1000;
                         
                            long t = time;

                            long hour = 0, min = 0, sec = 0;
                            if (time >= 3600) {
                                hour = time / 3600;
                                time = time % 3600;
                            }

                            if (time >= 60) {
                                min = time / 60;
                                time = time % 60;
                            }

                            sec = time;

                            if (t > 0) {
                        %>

                        <br>
                        <br>
                        <div class="col-lg-4 col-md-6">
                            <div class="panel panel-danger">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-xs-3">
                                            <i class="fa fa-clock-o fa-5x"></i>
                                        </div>
                                        <div class="col-xs-5 text-right">
                                            <!-- <div class="huge"><%=hour%>h &nbsp;<%=min%>m&nbsp; <%=sec%>s </div> -->
                                            <div class="huge"><%=hour%>:<%=min%>:<%=sec%> </div>
                                            <div>Wake Up Timer</div>
                                        </div>
                                    </div>
                                </div>
                                <a href="#">
                                    <div class="panel-footer">
                                        <!--                                    <span class="pull-left">View Details</span>
                                                                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span> -->
                                        <div class="clearfix"></div>
                                    </div>
                                </a>
                            </div>
                        </div>              

                        <%  } else {
                            mySession.setWakeUpTimerRunning(false);
                        %>
                        <br>
                        <br>
                        <div class="col-lg-4 col-md-6">
                            <div class="panel panel-danger">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-xs-3">
                                            <i class="fa fa-clock-o fa-5x"></i>
                                        </div>
                                        <div class="col-xs-9 text-right">
                                            <!--<div class="huge"><%=hour%>h &nbsp;<%=min%>m&nbsp; <%=sec%>s </div>-->
                                            <div>Timer Expired!!!</div>
                                        </div>
                                    </div>
                                </div>
                                <a href="#">
                                    <div class="panel-footer">
                                        <!--                                    <span class="pull-left">View Details</span>
                                                                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span> -->
                                        <div class="clearfix"></div>
                                    </div>
                                </a>
                            </div>
                        </div>              


                        <%
                            }
                        %>

                        <br>
                        <br>
                        <!--<a href="handleEvents.jsp?event=wakeUpStatusExit" class='btn btn-default' style="background-color: #e74c3c ;color: white;border-color:#e74c3c">Set New Timer</a>-->
                        <a href="utilities.jsp" class='btn btn-default' style="background-color: #e74c3c ;color: white;border-color:#e74c3c">Set New Timer</a>
                        <br>

                    </div>
                    <!-- /.col-lg-12 -->
                </div>

                <div class="row">
                    <br/>
                    
                      
                    <b>[Server Time &nbsp;:&nbsp; <%
                        Date date = new Date();
                        out.write(date.toString());
                    %> ]</b>
                        
                    
                    <br/><br/>
                    <div class="col-lg-12">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <b>Wake Up Request Status</b>&emsp;&emsp;
                                    <button  class="btn btn-default" onclick="self.close()">Exit Page</button>
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <!--<table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example">-->
                                <table width="100%" class="table table-striped table-bordered table-hover" >

                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Mac Address</th>
                                            <th>Last HearBeat</th>
                                            <th>Running in Foreground</th>
                                            <th>Request Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <%
                                            String filter = mySession.getWakeUpFilter();
                                            int count = 0;
                                            ConcurrentHashMap<String, DeviceInfo> clients = mySession.getSelectedConnectedClients();
                                            Enumeration<String> macs = clients.keys();

                                    if(filter.equalsIgnoreCase("bssid")){

                                        while(macs.hasMoreElements()){
                                            String mac = macs.nextElement();
                                            DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                        
                                        if(mySession.getWakeUpTimerSelectedClients().contains(device.getBssid())){ // bssid
                                            String status = "No selected";
                                             count ++;
                                            String temp1 = initilizeServer.getWakeUpTimerFilteredClients().get(mac);
                                            status = (temp1 != null)?temp1:status;
                                            out.write("<tr><td>" + count + "</td><td>" + mac + "</td><td>" + device.getLastHeartBeatTime() + "</td><td>"+    (device.isInForeground()?"<b style='color:blue'>True</b>":"<b>False</b>")  + "</td><td>" + status + "</td></tr>");
                                            }
                                        }
                                                

                                    }else if(filter.equalsIgnoreCase("ssid")){
                                        while(macs.hasMoreElements()){
                                            String mac = macs.nextElement();
                                            DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                            if(mySession.getWakeUpTimerSelectedClients().contains(device.getSsid())){ // ssid
                                                String status = "No selected";
                                                 count ++;
                                                String temp1 = initilizeServer.getWakeUpTimerFilteredClients().get(mac);
                                                status = (temp1 != null)?temp1:status;
                                                out.write("<tr><td>" + count + "</td><td>" + mac + "</td><td>" + device.getLastHeartBeatTime() + "</td><td>"+    (device.isInForeground()?"<b style='color:blue'>True</b>":"<b>False</b>")  + "</td><td>" + status + "</td></tr>");
                                                    
                                            }
                                        }
                                                 

                                    }else if(filter.equalsIgnoreCase("setToAll")){
                                        while(macs.hasMoreElements()){
                                            String mac = macs.nextElement();
                                            DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                             count ++;
                                            String status = "No selected";
                                            String temp1 = initilizeServer.getWakeUpTimerFilteredClients().get(mac);
                                            status = (temp1 != null)?temp1:status;
                                            out.write("<tr><td>" + count + "</td><td>" + mac + "</td><td>" + device.getLastHeartBeatTime() + "</td><td>"+    (device.isInForeground()?"<b style='color:blue'>True</b>":"<b>False</b>")  + "</td><td>" + status + "</td></tr>");
                                        }
                                                 

                                    }else if(filter.equalsIgnoreCase("clientSpecific")){
                                        while(macs.hasMoreElements()){
                                            String mac = macs.nextElement();
                                            DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                            if(mySession.getWakeUpTimerSelectedClients().contains(mac)){ // selected clients
                                                count ++;
                                                String status = "No selected";
                                                String temp1 = initilizeServer.getWakeUpTimerFilteredClients().get(mac);
                                                status = (temp1 != null)?temp1:status;
                                                out.write("<tr><td>" + count + "</td><td>" + mac + "</td><td>" + device.getLastHeartBeatTime() + "</td><td>"+    (device.isInForeground()?"<b style='color:blue'>True</b>":"<b>False</b>")  + "</td><td>" + status + "</td></tr>");
                                                    
                                            }
                                        }
                                    }
 
                                        %>

                                    </tbody>
                                </table>
                                <!-- /.table-responsive -->

                            </div>
                            <!-- /.panel-body -->
                        </div>
                        <!-- /.panel -->
                    </div>
                    <!-- /.col-lg-12 -->
                </div>
                <!--end Row -->

            </div>
            <%
                }}
            %>
            <!-- /#page-wrapper -->

        </div>
        <!-- /#wrapper -->

        <!-- jQuery -->
        <script src="/wicroft/vendor/jquery/jquery.min.js"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="/wicroft/vendor/bootstrap/js/bootstrap.min.js"></script>

        <!-- Metis Menu Plugin JavaScript -->
        <script src="/wicroft/vendor/metisMenu/metisMenu.min.js"></script>

        <!-- Morris Charts JavaScript -->
        <script src="/wicroft/vendor/raphael/raphael.min.js"></script>
        <script src="/wicroft/vendor/morrisjs/morris.min.js"></script>
        <script src="/wicroft/data/morris-data.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/wicroft/dist/js/sb-admin-2.js"></script>
        <!-- DataTables JavaScript -->
        <script src="/wicroft/vendor/datatables/js/jquery.dataTables.min.js"></script>
        <script src="/wicroft/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="/wicroft/vendor/datatables-responsive/dataTables.responsive.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/wicroft/dist/js/sb-admin-2.js"></script>

        <!-- Page-Level Demo Scripts - Tables - Use for reference -->
        <script>
            $(document).ready(function () {
                $('#dataTables-example').DataTable({
                    responsive: true
                });
            });
        </script>
<!--      <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                refresh();

            });
        </script>-->

    </body>

</html>
