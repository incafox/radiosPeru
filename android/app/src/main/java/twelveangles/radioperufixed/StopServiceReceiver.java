package twelveangles.radioperufixed;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.util.Log;
import android.widget.Toast;

public class StopServiceReceiver extends BroadcastReceiver {
    public static final int REQUEST_CODE = 333;
    boolean mBound = false;
    public static final String STOP_ACTION = "STOP_ACTION";
    PlayerService mService;


    @Override
    public void onReceive(Context context, Intent intent) {
        Toast.makeText(context,"RECIBIDO CADETE :V ",Toast.LENGTH_SHORT).show();
        //Log.v("[broadcastreceiver]"," APAGANDO");
        Intent service = new Intent(context, PlayerService.class);
        context.stopService(service);
        Intent it = new Intent("MyReceiver");
        context.sendBroadcast(it);
        //context.stopService(new Intent(context,NotificationService.class));
        //MainActivity.getInstance().stopPlayer();
        //Intent intento2 = new Intent(context, PlayerService.class);
        //context.bindService(intento2, mConnection2, Context.BIND_AUTO_CREATE);
        //mService.stopPlayer();
        // Start Activity
        //context.startForegroundService()
        // Intent activityIntent = new Intent(context, MainActivity.class);
        //activityIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
        //activityIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK );
        //context.startActivity(activityIntent);
        // Start Services
        //
        //context.startService(new Intent(context, PlayerService.class).setAction(STOP_ACTION));
        // Start Activity
        //Intent activityIntent = new Intent(context, MainActivity.class);
        //activityIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
        //context.startActivity(activityIntent);
        // Start Services
        //context.startService(new Intent(context, PlayerService.class).setAction("STOP_ACTION"));

        }
    /** Defines callbacks for service binding, passed to bindService() */
    private ServiceConnection mConnection2 = new ServiceConnection() {

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


}
