package net.ddns.zupanet.tablicaznakowa;

import android.graphics.Color;
import android.os.Bundle;
import android.view.Window;

import androidx.core.view.WindowCompat;
import androidx.core.view.WindowInsetsControllerCompat;

import org.qtproject.qt.android.bindings.QtActivity;

public class MainActivity extends QtActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        Window window = getWindow();

        // WYŁĄCZ edge-to-edge
        WindowCompat.setDecorFitsSystemWindows(window, true);

        // ustaw pełny kolor navigation bara
        window.setNavigationBarColor(Color.BLACK);

        // jasne ikonki na ciemnym tle
        WindowInsetsControllerCompat controller =
                new WindowInsetsControllerCompat(
                        window,
                        window.getDecorView()
                );

        controller.setAppearanceLightNavigationBars(false);
    }
}
