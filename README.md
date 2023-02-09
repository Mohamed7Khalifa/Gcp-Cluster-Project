# Gcp-Project
<hr>

build the repo with command:
```bash
docker build -t gcr.io/khalifa-iti-project/devops-challenge-image .
```
![image info](Screenshot/image-build.png)

then push this image to GCR:
```bash
docker push gcr.io/khalifa-iti-project/devops-challenge-image
```
![image info](Screenshot/push-image.png)
![image info](Screenshot/GCR-image.png)

```bash
docker build -t gcr.io/khalifa-iti-project/redis-challenge-image -f redis-dockerfile .
docker push gcr.io/khalifa-iti-project/redis-challenge-image
```
![image info](Screenshot/redis-image.png)

