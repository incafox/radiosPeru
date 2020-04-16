package twelveangles.radioperufixed;

//import android.support.v7.app.AppCompatActivity;

import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationCompat.Builder;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.Binder;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.support.annotation.RequiresApi;
//import android.support.v4.media.app.NotificationCompat;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.RemoteViews;
import android.widget.Toast;
//import android.support.v7.app.*;
import com.google.android.exoplayer2.DefaultLoadControl;
import com.google.android.exoplayer2.DefaultRenderersFactory;
import com.google.android.exoplayer2.ExoPlaybackException;
import com.google.android.exoplayer2.ExoPlayer;
import com.google.android.exoplayer2.ExoPlayerFactory;
import com.google.android.exoplayer2.LoadControl;
import com.google.android.exoplayer2.PlaybackParameters;
import com.google.android.exoplayer2.RenderersFactory;
import com.google.android.exoplayer2.SimpleExoPlayer;
import com.google.android.exoplayer2.Timeline;
import com.google.android.exoplayer2.extractor.DefaultExtractorsFactory;
import com.google.android.exoplayer2.extractor.ExtractorsFactory;
import com.google.android.exoplayer2.source.ExtractorMediaSource;
import com.google.android.exoplayer2.source.MediaSource;
import com.google.android.exoplayer2.source.TrackGroupArray;
import com.google.android.exoplayer2.trackselection.AdaptiveTrackSelection;
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector;
import com.google.android.exoplayer2.trackselection.TrackSelection;
import com.google.android.exoplayer2.trackselection.TrackSelectionArray;
import com.google.android.exoplayer2.trackselection.TrackSelector;
import com.google.android.exoplayer2.upstream.BandwidthMeter;
import com.google.android.exoplayer2.upstream.DataSource;
import com.google.android.exoplayer2.upstream.DefaultBandwidthMeter;
import com.google.android.exoplayer2.upstream.DefaultDataSourceFactory;

import java.util.Timer;

import io.flutter.plugins.GeneratedPluginRegistrant;
import io.grpc.Server;

public class PlayerService extends Service implements ExoPlayer.EventListener {

    String CHANNEL_ID = "com.app.app";
    public static final String ACTION_PAUSE = "ACTION_PAUSE";
    private static Timer timer = new Timer();
    private Context ctx;

    IBinder binder = new LocalBinder();
    public class LocalBinder extends Binder {
        PlayerService getService() {
            return PlayerService.this;
        }
    }
    public boolean isPlaying = false;

    private Handler mainHandler;
    private RenderersFactory renderersFactory;
    private BandwidthMeter bandwidthMeter;
    private LoadControl loadControl;
    private DataSource.Factory dataSourceFactory;
    private ExtractorsFactory extractorsFactory;
    private MediaSource mediaSource;
    private TrackSelection.Factory trackSelectionFactory;
    private SimpleExoPlayer player;
    private String streamUrl = "http://14003.live.streamtheworld.com/CRP_OAS_SC"; //bbc world service url
    private TrackSelector trackSelector;
    private final BroadcastReceiver myReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            // Code to run
            //Toast.makeText(context,"BROADCAST RECIBIDO CAPITAN :V ",Toast.LENGTH_SHORT).show();
            //stopPlayer();

            //cambia icono
            String action = intent.getAction();
            if (!TextUtils.isEmpty(action)) {
                //if (action == null) {
                //return START_STICKY;
                //}

                if (action != null && action.equals("PLAY_ACTION") && !isPlaying) {
                    //Toast.makeText(getApplicationContext(), "Radios Stereo: Play", Toast.LENGTH_LONG).show();
                    //player.pla();
                    //this.player.release();
                    //this.isPlaying = false;
                    startService(streamUrl);
                    isPlaying = true;
                }
                if (action != null && action.equals("play") && !isPlaying) {
                    //stopPlay("adasd");// here you invoke service method
                    //stopPlayer();
                    //Log.v("[BUTTON]  ", "close presionado");
                    //Toast.makeText(getApplicationContext(), "Lo apagaste perro.", Toast.LENGTH_LONG).show();
                }
                if (action != null && action.equals("STOP_ACTION")) {
                    //stopForeground(true);
                    //Log.v("[laservice] ", "fdafsdfgdgdfg");
                    //Log.v("[PLAYERSERVICE]", " APAGANDO");

                    //this.stopSelf();
                    //this.player.stop();
                    //this.player.release();
                    //Toast.makeText(getApplicationContext(), "Lo apagaste perroooooo.", Toast.LENGTH_LONG).show();
                    pausePlayer();
                    isPlaying = false;
                    //Toast.makeText(getApplicationContext(), "RECIBIDO CADETE :V ", Toast.LENGTH_SHORT).show();
                }
            }
        }
    };

    //@RequiresApi(api = Build.VERSION_CODES.O)
    public void onCreate()
    {
        super.onCreate();
        ctx = this;
        isPlaying = true;
        //funka
        //GeneratedPluginRegistrant.registerWith(this);
        /*
        Notification notification = new Notification(2, "ffa",
                System.currentTimeMillis());
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);
        //notification.setLatestEventInfo(this, "mierda",
        //        "dddd", pendingIntent);
        startForeground(1337, notification);
*/

        //startService(this.streamUrl);

    }
    //@RequiresApi(api = Build.VERSION_CODES.O)
    //@RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String data =(String) intent.getExtras().get("url");

        //Bundle extras = i.getExtras();
        Log.v("[SERVICE]  > ", data);
        this.streamUrl = data;
        createNotificationChannel();
        registerReceiver(myReceiver, new IntentFilter("STOP_ACTION"));
        registerReceiver(myReceiver, new IntentFilter("PLAY_ACTION"));

        //PendingIntent pSnoozeIntent = PendingIntent.getBroadcast(this,CHANNEL_ID,snoozeIntent,PendingIntent.FLAG_UPDATE_CURRENT);

        Intent notificationIntent = new Intent(this, MainActivity.class);

        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0,
                notificationIntent, 0);
        //Intent intento = new Intent(this);
        //startService(intento);
        //Activity currentActivity = MainActivity.getApplication().getCurrentActivity();
        RemoteViews contentView = new RemoteViews(getPackageName(), R.layout.custom_not_l);
        Intent intento = new Intent("STOP_ACTION");
        Intent intentoPlay = new Intent("PLAY_ACTION");

        //intento.setAction(ACTION_PAUSE);
        PendingIntent hideStop = PendingIntent.getBroadcast(getApplicationContext(), (int) 4, intento, PendingIntent.FLAG_CANCEL_CURRENT);
        PendingIntent hidePlay = PendingIntent.getBroadcast(getApplicationContext(), (int) 4, intentoPlay, PendingIntent.FLAG_CANCEL_CURRENT);

        Intent buttonsIntent = new Intent(this, PlayerService.class);
        buttonsIntent.putExtra("play", "play");
        //PendingIntent hide = PendingIntent.getForegroundService(this,0,buttonsIntent,0);


        Intent intentx = new Intent(this, StopServiceReceiver.class);
        PendingIntent contentIntentx = PendingIntent.getBroadcast(this, 0, intent, 0);
        //PendingIntent close_pendingIntent = PendingIntent.getActivity(this,0,intento,PendingIntent.FLAG_UPDATE_CURRENT);
        contentView.setOnClickPendingIntent(R.id.stopButton, hideStop);
        contentView.setOnClickPendingIntent(R.id.stopButton2, hidePlay);

        //contentView.setImageViewResource(R.id.image, R.mipmap.ic_launcher);
        //contentView.setTextViewText(R.id.title, "Custom notification");
        //contentView.setTextViewText(R.id.text, "This is a custom layout");
        //contentView.setOnClickPendingIntent(R.layout.custom_not_l, hideStop);


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O ) {
            Notification notification = new Notification.Builder(this, CHANNEL_ID)
                    .setSmallIcon(R.drawable.exo_controls_play)
                    .setColorized(true)
                    //.setLargeIcon(BitmapFactory.decodeResource(this.getResources(),
                    //        R.drawable.common_google_signin_btn_icon_light))
                    .setColor(Color.red(120))
                    //.setColor(Color.parseColor("#f7da64")
                    //.setContentTitle("New mail from " )
                    .setContentText("acacsc")
                    //.setStyle(new Notification. DecoratedCustomViewStyle() )//  MediaCustomViewStyle())
                    .setCustomContentView(contentView)
                    //.setLargeIcon(aBitmap)
                    .setContentIntent(contentIntentx)
                    //.setContentIntent(pendingIntent)
                    //.addAction(android.R.drawable.ic_media_play, "ulala",
                    //        hideStop)
                    .setOngoing(true)
                    .build();

            startService(this.streamUrl);
            isPlaying = true;
            startForeground(1337, notification);

        }
        else
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O)
            {   //NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this)
                //Notification n1 =  new NotificationCompat(this)
                NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                        // .setLargeIcon(image)/*Notification icon image*/
                        .setSmallIcon(R.drawable.exo_controls_play)
                        .setColorized(true)
                        .setColor(Color.red(120))
                        .setCustomContentView(contentView)
                        .setContentIntent(contentIntentx)
                        .setOngoing(true);
                        //.build();
                startService(this.streamUrl);
                isPlaying = true;
                //startForeground(1337, notificationBuilder);

            }

        //para los methods
        if (intent != null) {
            String action = intent.getAction();
            if (!TextUtils.isEmpty(action)) {
                //if (action == null) {
                //return START_STICKY;
                //}

                if (action != null && action.equals("STOP_ACTION2")) {
                    //Toast.makeText(getApplicationContext(), "Pausing.", Toast.LENGTH_LONG).show();
                    stopForeground(true);
                }
                if (action != null && action.equals("play")) {
                    //stopPlay("adasd");// here you invoke service method
                    //stopPlayer();
                    Log.v("[BUTTON]  ", "close presionado");
                    //Toast.makeText(getApplicationContext(), "Lo apagaste perro.", Toast.LENGTH_LONG).show();
                    this.stopSelf();
                    this.player.stop();
                    this.player.release();
                }
                if (action != null && action.equals("STOP_ACTION")) {
                    //stopForeground(true);
                    //Log.v("[laservice] ", "fdafsdfgdgdfg");
                    //Log.v("[PLAYERSERVICE]", " APAGANDO");
                    //this.stopSelf();
                    //this.player.stop();
                    //this.player.release();
                    //Toast.makeText(getApplicationContext(), "Lo apagaste perro.", Toast.LENGTH_LONG).show();
                    //Toast.makeText(getApplicationContext(), "RECIBIDO CADETE :V ", Toast.LENGTH_SHORT).show();
                }
            }
        }

        //return START_NOT_STICKY; //or return START_REDELIVER_INTENT;
        return super.onStartCommand(intent, flags, startId);
    }

    public void stopPlay(String streamUrl){
        //this.player.stop();
        stopForeground(true);
        stopSelf();
       // Log.v("[SERVICE METHOD]","sdsfs");
    }
    /*
    public PlayerService()
    {
        super("PlayerService");
    }*/

    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }
    /*
    @Override
    protected void onHandleIntent( Intent intent) {
        startService();
    }*/

    private void startService(String Url)
    {
        //Log.v("[STREAMING] ","SERVICE");
        //timer.scheduleAtFixedRate(new mainTask(), 0, 5000);
        renderersFactory = new DefaultRenderersFactory(getApplicationContext());
        bandwidthMeter = new DefaultBandwidthMeter();
        trackSelectionFactory = new AdaptiveTrackSelection.Factory(bandwidthMeter);
        trackSelector = new DefaultTrackSelector(trackSelectionFactory);
        loadControl = new DefaultLoadControl();
        player = ExoPlayerFactory.newSimpleInstance(renderersFactory, trackSelector, loadControl);
        player.addListener(this);

        dataSourceFactory = new DefaultDataSourceFactory(getApplicationContext(), "ExoplayerDemo");
        extractorsFactory = new DefaultExtractorsFactory();
        mainHandler = new Handler();
        mediaSource = new ExtractorMediaSource(Uri.parse(Url),
                dataSourceFactory,
                extractorsFactory,
                mainHandler,
                null);
        player.prepare(mediaSource);
        player.setPlayWhenReady(true);
        //Log.v("servicio lanzado","tmr");


    }

    @Override
    public void onTimelineChanged(Timeline timeline, Object manifest) {

    }

    @Override
    public void onTracksChanged(TrackGroupArray trackGroups, TrackSelectionArray trackSelections) {

    }


    @Override
    public void onLoadingChanged(boolean isLoading) {

    }

    @Override
    public void onPlayerStateChanged(boolean playWhenReady, int playbackState) {

    }

    @Override
    public void onPlayerError(ExoPlaybackException error) {

    }


    @Override
    public void onPositionDiscontinuity() {

    }

    @Override
    public void onPlaybackParametersChanged(PlaybackParameters playbackParameters) {

    }
    @Override
    public void onDestroy()
    {
        try {
            super.onDestroy();
            stopForeground(true);
            this.stopSelf();
            this.player.stop();
            this.player.release();
        }catch (Exception e)
        {
            //Toast.makeText(this, "Radio Apagada ...", Toast.LENGTH_SHORT).show();
        }
        //Toast.makeText(this, "Radio Apagada ...", Toast.LENGTH_SHORT).show();
    }
    public void stopPlayer(){
        //if (isPlaying){
        //Log.v("[PlayerService] ","stopPlayer() invoked");
            stopForeground(true);
            this.stopSelf();
            this.player.stop();
            this.player.release();
        //}
    }

    public void pausePlayer(){
        //if (isPlaying){
        //Toast.makeText(this,"Radios Stereo: Pausa",Toast.LENGTH_SHORT).show();
        //Log.v("[PlayerService] ","stopPlayer() invoked");
        //stopForeground(true);
        //this.stopSelf();
        this.player.stop();
        this.player.release();
        this.isPlaying = false;
        //}
    }


    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "ad";
            String description = "ad";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);
            channel.setSound(null,null);
            channel.enableVibration(false);
            channel.enableLights(false);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }


    @Override
    public void onTaskRemoved(Intent rootIntent) {
        System.out.println("onTaskRemoved called");
        super.onTaskRemoved(rootIntent);
        //do something you want
        //stop service
        this.stopSelf();
    }



}
