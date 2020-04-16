package twelveangles.radioperufixed;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Toast;

public class NotifyActivityHandler extends Activity {
    public static final String PERFORM_NOTIFICATION_BUTTON = "perform_notification_button";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        String action = (String) getIntent().getExtras().get("do_action");
        if (action != null) {
            if (action.equals("play")) {
                Toast.makeText(this,"PLAY CTM :V ",Toast.LENGTH_SHORT).show();
                // for example play a music
            } else if (action.equals("close")) {
                Toast.makeText(this,"CLOSE CTM :V ",Toast.LENGTH_SHORT).show();

                // close current notification
            }
        }

        finish();
    }
}
