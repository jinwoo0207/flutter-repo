class VideoModel {   // videomodel 클래스 : 동영상 정보를 저장하는 모델

  final String id; // 동영상 ID

  final String title; // 동영상 제목

  VideoModel({   // 생성자 : videoModel 인스턴스를 생성할 때 사용
    required this.id, // ID는 필수 매개변수
    required this.title, // 제목은 필수 매개변수
  });
}