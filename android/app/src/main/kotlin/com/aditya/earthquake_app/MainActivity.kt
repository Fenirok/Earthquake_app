package com.aditya.earthquake_app

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "native_location"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getLocation") {
                    val location = getLastKnownLocation()
                    if (location != null) {
                        result.success(
                            mapOf(
                                "latitude" to location.latitude,
                                "longitude" to location.longitude
                            )
                        )
                    } else {
                        result.error("NO_LOCATION", "Location unavailable", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getLastKnownLocation(): Location? {
        val locationManager =
            getSystemService(Context.LOCATION_SERVICE) as LocationManager

        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return null
        }

        val providers = locationManager.getProviders(true)
        for (provider in providers.reversed()) {
            val location = locationManager.getLastKnownLocation(provider)
            if (location != null) return location
        }
        return null
    }
}
