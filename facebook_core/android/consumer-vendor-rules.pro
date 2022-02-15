-keepclassmembers,allowoptimization enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keepclassmembers class * implements java.io.Serializable {
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

-keepnames class com.facebook.FacebookActivity
-keepnames class com.facebook.CustomTabActivity

-keepnames class com.android.installreferrer.api.InstallReferrerClient
-keepnames class com.android.installreferrer.api.InstallReferrerStateListener
-keepnames class com.android.installreferrer.api.ReferrerDetails

-keep class com.facebook.core.Core

# keep class names and method names used by reflection by InAppPurchaseEventManager
-keep public class com.android.vending.billing.IInAppBillingService {
    public <methods>;
}
-keep public class com.android.vending.billing.IInAppBillingService$Stub {
    public <methods>;
}