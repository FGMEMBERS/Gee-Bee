##########################################################
######## Modified by BACON Guillaume for Gee-Bee #########
##########################################################

var magnetoL = props.globals.getNode("/controls/engines/engine/magnetoL",1).getBoolValue();
var magnetoR = props.globals.getNode("/controls/engines/engine/magnetoR",1).getBoolValue();
var magnetos = props.globals.getNode("/controls/engines/engine/magnetos",1).getBoolValue();
var cranking = props.globals.getNode("/engines/engine/cranking",1).getBoolValue();
var running = props.globals.getNode("/engines/engine/running",1).getBoolValue();
var starter = props.globals.getNode("/controls/engines/engine/starter",1).getBoolValue();
var starter_serviceable = 0;
var cranking_serviceable = 0;
var engine_serviceable = 0;

setlistener("/sim/signals/fdm-initialized", func{
  setprop("/sim/sound/volume",1.0);
  settimer(update_system, 1);
  setprop("/controls/gear/brake-parking",1);
  setprop("/instrumentation/doors/crew/position-norm",1);
});

setlistener("/sim/current-view/view-number", func(vw) {
    var nm = vw.getValue();
    setprop("sim/model/sound/volume", 1.0);
    if(nm == 0 or nm == 7)setprop("sim/model/sound/volume", 0.5);
},1,0);


setlistener("/instrumentation/airspeed-indicator/indicated-speed-kt", func(asi) {
    var speed = asi.getValue();
    speed = speed * 0.539;
    setprop("/instrumentation/airspeed-indicator/indicated-speed-kmh", speed);
});
##############################################
######### AUTOSTART / AUTOSHUTDOWN ###########
##############################################

setlistener("/sim/model/start-idling", func(idle){
    var run= idle.getBoolValue();
    if(run){
    Startup();
    }else{
    Shutdown();
    }
},0,0);

var Startup = func {
  setprop("/controls/electric/key",1);
  setprop("/controls/engines/engine/magnetoL",1);
  setprop("/controls/engines/engine/magnetoR",1);
  setprop("/controls/engines/engine/magnetos",3);
  setprop("/engines/engine/rpm",750);
  setprop("/engines/engine/running",1);
  setprop("/controls/gear/brake-parking",0);
  setprop("/instrumentation/doors/crew/position-norm",0);
}

var Shutdown = func {
  setprop("/controls/electric/key",0);
  setprop("/controls/engines/engine/magnetoL",0);
  setprop("/controls/engines/engine/magnetoR",0);
  setprop("/controls/engines/engine/magnetos",0);
  setprop("/engines/engine/rpm",0);
  setprop("/engines/engine/running",0);
  setprop("/controls/gear/brake-parking",1);
  setprop("/instrumentation/doors/crew/position-norm",1);
}

###############################################
###############################################
###############################################

var update_system = func{
  settimer(update_system, 0);
}
    
