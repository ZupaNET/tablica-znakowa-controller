package pl.zupanet.prezenter;

import android.graphics.Color;
import android.os.Bundle;
import android.view.Window;
import android.view.WindowManager;

import androidx.core.view.WindowCompat;
import androidx.core.view.WindowInsetsControllerCompat;

import org.qtproject.qt.android.bindings.QtActivity;

public class MainActivity extends QtActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
		
		// Let's embrace it
		Window window = getWindow();
		WindowCompat.enableEdgeToEdge(window);
		
		WindowInsetsControllerCompat controller =
        new WindowInsetsControllerCompat(
                window,
                window.getDecorView()
        );

		controller.setAppearanceLightStatusBars(false);
		controller.setAppearanceLightNavigationBars(false);
		
		/*
        Window window = getWindow();

        // WYŁĄCZ edge-to-edge
        WindowCompat.setDecorFitsSystemWindows(window, true);

        // ustaw pełny kolor navigation i status bara
        window.setStatusBarColor(Color.BLACK);
		window.setNavigationBarColor(Color.BLACK);
		window.setSoftInputMode(
            WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE
        );

        // jasne ikonki na ciemnym tle
        WindowInsetsControllerCompat controller =
                new WindowInsetsControllerCompat(
                        window,
                        window.getDecorView()
                );
        controller.setAppearanceLightNavigationBars(false);
		controller.setAppearanceLightStatusBars(false);
		*/
    }
}
