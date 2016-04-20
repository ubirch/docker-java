# Java Base image
This Dockerfile will create a basic image that contains Oracle JAVA preinstalled.

To get a specific Version of Java you have to adjust the three version parameters in the header of the Dockerfile.

Best way to figure those out is to open the Java Downloads page in your browser and manually download the JDK. That way you'll see the URL and the Version, Update and Build number.

# Build instructions
Adjust the Version information in the header and then just call a normal Docker build. Make sure to tag the new image appropriately.

```
docker build -t ubirch/java:v8 .
```
