pipeline {
    agent any  // Master node pe hi run hoga

    tools {
        maven 'Maven'     // Yeh name Step 1 mein diya gaya naam
        jdk 'JDK'       // Yeh name Step 2 mein diya gaya naam
    }
    
    environment {
        DOCKER_IMAGE = 'kamleshdv/java-app'
        SONAR_HOST_URL = 'http://13.203.215.2:9000'  // Agar same machine pe SonarQube hai
    }
    
    stages {
        stage('1. GitHub Se Code Lana') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/kamleshdv/three-tier-java-application.git'
                    
                
                echo "✅ Code fetch ho gaya"
            }
        }
        
        stage('2. SonarQube Se Check Karna') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn clean verify sonar:sonar \
                            -Dsonar.projectKey=insureme \
                            -Dsonar.host.url=${SONAR_HOST_URL}
                    '''
                }
            }
        }
        
        stage('3. Docker Image Banana') {
            steps {
                script {
                    env.IMAGE_TAG = "${BUILD_NUMBER}"
                    
                    sh '''
                        docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                        docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
                        
                        echo "✅ Docker image ban gaya"
                    '''
                }
            }
        }
        
        stage('4. Trivy Se Image Scan') {
            steps {
                sh '''
                    echo "🔍 Trivy scan chal raha hai..."
                    trivy image --severity HIGH,CRITICAL --exit-code 0 ${DOCKER_IMAGE}:${IMAGE_TAG}
                    echo "✅ Scan complete"
                '''
            }
        }
        
        stage('5. Docker Hub Pe Push') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        sh '''
                            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_IMAGE}:latest
                            echo "✅ Docker Hub pe push ho gaya!"
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "🎉 Pipeline successful! Image: ${DOCKER_IMAGE}:${env.IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline failed! Check logs."
        }
    }
}
