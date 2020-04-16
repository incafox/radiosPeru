package twelveangles.radioperufixed;

import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.google.android.gms.common.api.Api;

import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  Intent intento;//; = new Intent(MainActivity.this, PlayerService.class);//= new Intent(this, PlayerService.class);
  Boolean isPlaying= false;
  Context context = this;
  PlayerService mService;
  boolean mBound = false;
  private static MainActivity instance;
  boolean hayAlgoCorriendo = false;

  private BroadcastReceiver receiver = new BroadcastReceiver() {

    @Override
    public void onReceive(Context context, Intent intent) {
      Bundle bundle = intent.getExtras();
      if (intent.getAction().equals("stopPlay")) {
        //doCustomAction();
      }
      if (bundle != null) {
        String string = bundle.getString(PlayerService.ACTIVITY_SERVICE);
        int resultCode = bundle.getInt(PlayerService.ACCOUNT_SERVICE);
        if (resultCode == RESULT_OK) {
          Toast.makeText(MainActivity.this,
                  "Download complete. Download URI: " + string,
                  Toast.LENGTH_LONG).show();
          //textView.setText("Download done");
        }
      }
    }
  };
  private static final String CHANNEL="player.pe";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    instance = this;


    /*
    Button stopServiceButton = (Button)findViewById(R.id.stopButton);
    stopServiceButton.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        //Intent intent = new Intent(MainActivity.this, PlayerService.class);
        //intent.setAction(PlayerService.ACTION_PAUSE);
        //stopService(intent);
      }
    });
    */
  }

  public void stopPlayer() {
    intento = new Intent(MainActivity.this, PlayerService.class);
    bindService(intento, mConnection, Context.BIND_AUTO_CREATE);
    mService.stopPlayer();
  }

  public static MainActivity getInstance() {
    return instance;
  }
  @Override
  protected void onStart() {
    super.onStart();
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        final Map<String, Object> arguments = methodCall.arguments();
        if (methodCall.method.equals("play"))
        {
          intento = new Intent(MainActivity.this, PlayerService.class);
          bindService(intento, mConnection, Context.BIND_AUTO_CREATE);
          if (mBound || true){
            //stopService(intento);
            try{
              mService.stopPlayer();
            }catch (Exception e){

            }

            Log.v("[DETECTED] ","LOL");
          }
          String message   = "te vas a la ctm";
          String arg1 = (String) arguments.get("url");
          Log.v("[JAVA] ",arg1);
          result.success(message);
          intento.putExtra("url",arg1);
          startService(intento);
          isPlaying = true;
        }
        if (methodCall.method.equals("stop"))
        {
            intento = new Intent(MainActivity.this, PlayerService.class);
            bindService(intento, mConnection, Context.BIND_AUTO_CREATE);
            //mService.stopPlayer();
            mService.pausePlayer();
            Log.v("[DETECTED] ","LOL");
            result.success(isPlaying.toString());
        }
      }
    });
    // Bind to LocalService
    //intento = new Intent(MainActivity.this, PlayerService.class);
    //bindService(intento, mConnection, Context.BIND_AUTO_CREATE);


  }




  private boolean isMyServiceRunning(Class<?> serviceClass) {
    ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
    for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
      if (serviceClass.getName().equals(service.service.getClassName())) {
        return true;
      }
    }
    return false;
  }


  public static boolean isServiceRunningInForeground(Context context, Class<?> serviceClass) {
    ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
    for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
      if (serviceClass.getName().equals(service.service.getClassName())) {
        if (service.foreground) {
          return true;
        }

      }
    }
    return false;
  }

  /** Defines callbacks for service binding, passed to bindService() */
  private ServiceConnection mConnection = new ServiceConnection() {

    @Override
    public void onServiceConnected(ComponentName className,
                                   IBinder service) {
      // We've bound to LocalService, cast the IBinder and get LocalService instance
      PlayerService.LocalBinder binder = (PlayerService.LocalBinder) service;
      mService = binder.getService();
      mBound = true;
    }

    @Override
    public void onServiceDisconnected(ComponentName arg0) {
      mBound = false;
    }
  };
/*
  @Override
  protected void onResume()
  {
    super.onResume();
    Toast.makeText(this,"ctmmmmm",Toast.LENGTH_SHORT).show();
    Toast.makeText(getApplicationContext(), "Radios: play", Toast.LENGTH_LONG).show();

  }*/

  @Override
  protected void onResume()
  {
    super.onResume();

    try {
      intento = new Intent(MainActivity.this, PlayerService.class);
      bindService(intento, mConnection, Context.BIND_AUTO_CREATE);

      if (mBound) {
        //entonces hay un service corriendo xd :v
        this.hayAlgoCorriendo = true;
        //Toast.makeText(this,"onresume true",Toast.LENGTH_LONG).show();
      }
    }catch (Exception e){

      //Toast.makeText(MainActivity.this,
        //      "[resume ]no hay nada perro " ,
          //    Toast.LENGTH_LONG).show();
    }
    //Toast.makeText(this,"resumeee",Toast.LENGTH_LONG).show();

  }

  @Override
  protected void onStop() {
    super.onStop();
    //Toast.makeText(this,"onstop",Toast.LENGTH_LONG).show();
  }

  @Override
  protected void onDestroy() {
    super.onDestroy();
    try {
      unbindService(mConnection);
    }catch (Exception e) {

    }
    //Toast.makeText(this,"onDestroy",Toast.LENGTH_LONG).show();
  }

  @Override
  protected void onRestart() {
    super.onRestart();

    try {
      intento = new Intent(MainActivity.this, PlayerService.class);
      bindService(intento, mConnection, Context.BIND_AUTO_CREATE);

      if (mBound) {
        //entonces hay un service corriendo xd :v
        this.hayAlgoCorriendo = true;
      }
    }catch (Exception e){
     // Toast.makeText(MainActivity.this,
       //       "restart estado " ,
         //     Toast.LENGTH_LONG).show();
    }
    //Toast.makeText(this,"restarttt",Toast.LENGTH_LONG).show();
  }




/*
  @Override
  protected void onStart() {
    super.onStart();
    Intent mIntent = new Intent(this, PlayerService.class);
    bindService(mIntent, mConnection, BIND_AUTO_CREATE);
  };*/
/*
  ServiceConnection mConnection = new ServiceConnection() {

    public void onServiceDisconnected(ComponentName name) {
      //Toast.makeText(Api.Client.this, "Service is disconnected", 1000).show();
      //mBounded = false;
      playerService = null;
    }

    public void onServiceConnected(ComponentName name, IBinder service) {
      //Toast.makeText(Api.Client.this, "Service is connected", 1000).show();
      //mBounded = true;
      PlayerService.LocalBinder mLocalBinder = (PlayerService.LocalBinder)service;
      playerService = mLocalBinder.getService();
    }
  };*/

}
