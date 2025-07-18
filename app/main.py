from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "GitOps 기반 EKS CI/CD 프로젝트에 오신 것을 환영합니다! ArgoCD 테스트중"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)