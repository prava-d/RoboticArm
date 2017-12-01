
#include <vector>
#include <fstream>
#include <iostream>
#include <math.h>
#include <unistd.h>

#include <opencv2/opencv.hpp>
#include "opencv2/video/background_segm.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace cv;
using namespace std;

// main function for background subtractor
int main(int argc, const char** argv)
{
  
Ptr<BackgroundSubtractor> bg_model = createBackgroundSubtractorMOG2().dynamicCast<BackgroundSubtractor>();

Mat img, foregroundMask, backgroundImage, foregroundImg;

VideoCapture cap(0);

for(;;){

     bool ok = cap.grab();

  if (ok == false){

          std::cout << "Video Capture Fail" << std::endl ; 


          }
          else{

               cap.retrieve(img, CV_CAP_OPENNI_BGR_IMAGE);

               // sleep(10);

              if( foregroundMask.empty() ){
                  foregroundMask.create(img.size(), img.type());
               }
   
              
              bg_model->apply(img, foregroundMask, true ? -1 : 0);
              
              GaussianBlur(foregroundMask, foregroundMask, Size(11,11), 3.5,3.5);
              
              threshold(foregroundMask, foregroundMask, 10,255,THRESH_BINARY);
              
              foregroundImg = Scalar::all(0);
              
              img.copyTo(foregroundImg, foregroundMask);

              // cv::Mat merged (foregroundMask.cols, foregroundMask.rows, CV_8UC4);

              // addWeighted(foregroundImg, 0.5, foregroundMask, 0.5, 0.0, merged);
       
              cv::Mat grey;

              cvtColor(foregroundImg, grey, cv::COLOR_RGB2GRAY);

              cv::Mat1b bin = grey > 80;

              vector <Point> points;
              findNonZero(bin, points);

              Rect box = boundingRect(points);

              Mat3b out;
              cvtColor(grey, out, COLOR_GRAY2BGR);
              rectangle(out, box, Scalar(0, 255, 0), 3);

              // imshow("added images", dst);
              imshow("g", out);
             // imshow("foreground mask", foregroundMask);
             // imshow("foreground image", foregroundImg);

             waitKey(40);
        


         }

      }

}
