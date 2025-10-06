package com.etqan4edu.app

import android.content.Context
import android.graphics.Color
import android.hardware.display.DisplayManager
import android.os.Build
import android.os.Bundle
import android.view.Display
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private lateinit var displayManager: DisplayManager
    private var blurOverlay: View? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 1) Block screenshots & recordings at the OS level
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )

        // 2) Watch for external displays (casting/mirroring)
        displayManager = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        displayManager.registerDisplayListener(displayListener, null)

        // 3) Hook into window insets to re-check on screen‐recording start/stop
        window.decorView.setOnApplyWindowInsetsListener { _, insets ->
            checkScreenCaptureOrRecording()
            insets
        }

        // 4) Initial check
        checkScreenCaptureOrRecording()
    }

    /** Detects if any external display (presentation) is active */
    private fun isScreenBeingCaptured(): Boolean =
        displayManager.displays.any { (it.flags and Display.FLAG_PRESENTATION) != 0 }

    /**
     * Detects screen recording on Android Q+ by reflection.
     * Falls back to false on older releases.
     */
    private fun isScreenBeingRecorded(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            return try {
                val m = View::class.java.getMethod("isCapturedByAnotherApp")
                (m.invoke(window.decorView) as? Boolean) == true
            } catch (_: Exception) {
                false
            }
        }
        return false
    }

    /** Show or hide the overlay based on casting/recording state */
    private fun checkScreenCaptureOrRecording() {
        if (isScreenBeingCaptured() || isScreenBeingRecorded()) {
            showBlurOverlay()
        } else {
            removeBlurOverlay()
        }
    }

    /** Add a full-screen black, touch-blocking overlay with fade-in */
    private fun showBlurOverlay() {
        if (blurOverlay != null) return

        val overlay = View(this).apply {
            setBackgroundColor(Color.BLACK)
            isClickable = true   // absorb all taps
            isFocusable = true   // absorb focus
            alpha = 0f           // start transparent
        }

        addContentView(
            overlay,
            FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
        )

        overlay.animate()
            .alpha(1f)
            .setDuration(300)
            .start()

        blurOverlay = overlay
    }

    /** Fade-out and remove the overlay */
    private fun removeBlurOverlay() {
        blurOverlay?.let { overlay ->
            overlay.animate()
                .alpha(0f)
                .setDuration(300)
                .withEndAction {
                    (overlay.parent as? ViewGroup)?.removeView(overlay)
                    blurOverlay = null
                }
                .start()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        displayManager.unregisterDisplayListener(displayListener)
        window.decorView.setOnApplyWindowInsetsListener(null)
    }

    private val displayListener = object : DisplayManager.DisplayListener {
        override fun onDisplayAdded(displayId: Int)   = checkScreenCaptureOrRecording()
        override fun onDisplayChanged(displayId: Int) = checkScreenCaptureOrRecording()
        override fun onDisplayRemoved(displayId: Int) = checkScreenCaptureOrRecording()
    }
}
