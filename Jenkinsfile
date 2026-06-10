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
        
        stage('Trivy Scan & Report Gen') {
            steps {
                sh '''
                    echo "🔍 Trivy scan aur report generate ho rahi hai..."
                    mkdir -p trivy-reports-${BUILD_NUMBER}
                    
                    # JSON report (yeh kaam karega)
                    trivy image --severity HIGH,CRITICAL --exit-code 0 ${DOCKER_IMAGE}:${IMAGE_TAG} \
                        --format json -o trivy-reports-${BUILD_NUMBER}/report.json
                    
                    # HTML report - SAHI PATH
                    trivy image --severity HIGH,CRITICAL --exit-code 0 ${DOCKER_IMAGE}:${IMAGE_TAG} \
                        --format template --template "@/usr/local/share/trivy/templates/html.tpl" \
                        -o trivy-reports-${BUILD_NUMBER}/report.html
                    
                    echo "✅ Scan complete."
                '''
            }
        }
        
        stage('Upload Reports to S3') {
            steps {
                withAWS(credentials: 'awscred', region: 'ap-south-1') {
                    s3Upload(
                        file: "trivy-reports-${BUILD_NUMBER}",
                        bucket: 'kamleshjenkins9982',
                        path: "jenkins-build-${BUILD_NUMBER}/"
                    )
                }
                echo "✅ Reports S3 mein upload ho gayi."
            }
        }
        
        stage('5. Docker Hub Pe Push') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhubpass') {
                        docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push()
                        docker.image("${DOCKER_IMAGE}:latest").push()
                    }
                    echo "✅ Docker Hub pe push ho gaya!"
                }
            }
        }
    }
    
    // ✅ SIRF EK POST BLOCK - dono conditions andar
    post {
        success {
            echo "🎉 Pipeline successful! Image: ${DOCKER_IMAGE}:${env.IMAGE_TAG}"
            #emailext (
                subject: "✅ SUCCESS: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                body: "Build successful!\n\nProject: ${env.JOB_NAME}\nBuild: ${env.BUILD_NUMBER}\nDocker Image: ${env.DOCKER_IMAGE}:${env.IMAGE_TAG}\nURL: ${env.BUILD_URL}",
                to: 'kamleshjaipur2039@gmail.com'
            )
        }
        failure {
            echo "❌ Pipeline failed! Check logs."
            #emailext (
                subject: "❌ FAILED: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                body: "Build failed!\n\nProject: ${env.JOB_NAME}\nBuild: ${env.BUILD_NUMBER}\nCheck logs: ${env.BUILD_URL}console",
                to: 'kamleshjaipur2039@gmail.com'
            )
        }
    }
}
