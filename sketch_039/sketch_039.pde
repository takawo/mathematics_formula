/*  mathematics formula */
//  inspired https://twitter.com/ru_sack/status/786738391677227009
//
// x=cos(u)*cos(v)^2
// y=sin(v)^2+0.5u
// z=sin(u)*cos(v)
// -2pi≦u≦2pi
// -pi≦v≦pi

import gifAnimation.*;

// 変数
GifMaker gifExport;
int gifCount = 90;
boolean isRecord = true;

// 変数uの最小値
float minU = -TWO_PI;
// 変数uの最大値
float maxU = TWO_PI;
// 変数vの最小値
float minV = -PI;
// 変数vの最大値
float maxV = PI;
// 分割数
float div = 200;

// u,vの増加ステップ
float stepU = abs(maxU - minU)/div;
float stepV = abs(maxU - minU)/div;

// スケール
float scale = 130;

// 背景、ベース、キー色
color bgColor;
color keyColor;
color baseColor;

// setup関数 : 初回1度だけ実行される
void setup() {
  size(960, 540, P3D); // ウィンドウサイズを960px,540pxに
  colorMode(HSB, 360, 100, 100, 100); // HSBでの色指定にする
  smooth(); // 描画を滑らかに
  blendMode(ADD);
  //hint(ENABLE_DEPTH_SORT);
  sphereDetail(16);

  bgColor = color(170, 10, 5);
  keyColor = color(195, 14, 37);
  baseColor = color(270, 100, 30);

  gifInit();
}

// draw関数 : setup関数実行後繰り返し実行される
void draw() {
  background(bgColor);
  lights();
  ambientLight(0, 0, 40);
  translate(width/2, height/2, -500);

  float n = sin(frameCount/(float)gifCount * PI);
  float fov = map(n, -1, 1, -1, 1.0);  //視野角
  //perspective(視野角、縦横の比率、近い面までの距離、遠い面までの距離)
  perspective(fov, float(width)/float(height), 1.0, 10000.0);


  rotateX(PI/2);
  rotateY(-PI/2 + map(pow(sin(frameCount*(TWO_PI/(float)gifCount)),3),-1,1,-PI/4,PI/4));
  rotateZ(PI + map(pow(sin(frameCount*(TWO_PI/(float)gifCount)), 1), -1, 1, -PI, PI));
  // rotateX(PI/2+ map(pow(sin(frameCount*(TWO_PI/(float)gifCount)),5),-1,1,0,PI));
  // rotateY(PI/2 + map(pow(sin(frameCount*(TWO_PI/(float)gifCount)),3),-1,1,-PI/4,PI/4));
  // rotateZ(map(pow(sin(frameCount*(TWO_PI/(float)gifCount)),1),-1,1,-PI,PI));

  stroke(keyColor);
  strokeWeight(.5);
  line(0, 3000, 0, 0, -3000, 0);
  noFill();
  fill(baseColor);
  noStroke();
  for (float v = minV; v <= maxV; v += stepV) {
    for (float u = minU; u <= maxU; u += stepU) {
      float x = cos(u) * pow(cos(v), 2);
      float y = pow(sin(v), 2) + 0.5 * u;
      float z = sin(u) * cos(v);
      x *= scale;
      y *= scale;
      z *= scale;
      pushMatrix();
      translate(x, y, z);
      // stroke(baseColor);
      // point(0,0,0);
      fill(baseColor);
      sphere(6);
      popMatrix();
    }
  }
  gifDraw();
}

void gifInit() {
  if (isRecord == false) {
    return;
  }
  gifExport = new GifMaker(this, getClass().getSimpleName() +".gif"); // ファイル名のGIFアニメーションを作成
  gifExport.setRepeat(0); // エンドレス再生
  gifExport.setQuality(8); // クオリティ(デフォルト10)
  gifExport.setDelay(33); // アニメーションの間隔を30ms(33fps)に
}

void gifDraw() {
  if (isRecord == false) {
    return;
  }
  //GIFアニメーションの保存
  if (frameCount <= gifCount) {
    gifExport.addFrame(); // フレームを追加
  } else {
    gifExport.finish(); // 終了してファイル保存
    exit();
  }
}