/**
	Trying out some object detection stuff.
**/

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <math.h>
#include <vector>
#include <fstream>
#include <iostream>
#include <unistd.h>

using namespace std;
using namespace cv;

bool detectGreen(cv::Mat src)
{
	cv::Mat buf;

	int greenLower[] = {29, 86, 6};
	int greenUpper[] = {64, 255, 255};

	// converts RBG to HSV
	cv::cvtColor(src, buf, cv::COLOR_BGR2HSV);

	// checks whether it is within range
	cv::Mat thresh;
	cv::inRange(buf, Scalar(greenLower[0], greenLower[1], greenLower[2]), Scalar(greenUpper[0], greenUpper[1], greenUpper[2]), thresh);

	// determines whether flag should be set or not
	double sumWhite = 0;

	int white[] = {255, 255, 255};

	double rows = thresh.rows;
	double cols = thresh.cols;

	int i;
	int j;
	for (i = 0; i < rows; i++)
	{
		for (j = 0; j < cols; j++)
		{
			Vec3b pixel = thresh.at<Vec3b>(Point(i, j));

			if (((int) pixel[0]) == white[0] &&
				((int) pixel[1]) == white[1] &&
				((int) pixel[2]) == white[2])
				sumWhite += 1;
		}
	}

	if (sumWhite/(rows*cols) >= 0.125)
		return 1;
	else
		return 0;
}

bool detectRed(cv::Mat src)
{
	cv::Mat buf;

	int redUpper1[] = {10, 255, 255};
	int redLower1[] = {0, 100, 100};

	int redUpper2[] = {179, 255, 255};
	int redLower2[] = {160, 100, 100};

	// converts RBG to HSV
	cv::cvtColor(src, buf, cv::COLOR_BGR2HSV);

	// checks whether it is within range
	cv::Mat thresh1;
	cv::inRange(buf, Scalar(redLower1[0], redLower1[1], redLower1[2]), Scalar(redUpper1[0], redUpper1[1], redUpper1[2]), thresh1);

	cv::Mat thresh2;
	cv::inRange(buf, Scalar(redLower2[0], redLower2[1], redLower2[2]), Scalar(redUpper2[0], redUpper2[1], redUpper2[2]), thresh2);

	cv::Mat thresh;
	cv::addWeighted(thresh1, 1.0, thresh2, 1.0, 0.0, thresh);

	// determines whether flag should be set or not
	double sumWhite = 0;

	int white[] = {255, 255, 255};

	double rows = thresh.rows;
	double cols = thresh.cols;

	int i;
	int j;
	for (i = 0; i < rows; i++)
	{
		for (j = 0; j < cols; j++)
		{
			Vec3b pixel = thresh.at<Vec3b>(Point(i, j));

			if (((int) pixel[0]) == white[0] &&
				((int) pixel[1]) == white[1] &&
				((int) pixel[2]) == white[2])
				sumWhite += 1;
		}
	}

	if (sumWhite/(rows*cols) >= 0.125)
		return 1;
	else
		return 0;
}

int main(int argc, char** argv )
{

	// cv::Mat img = imread("test.jpg", CV_LOAD_IMAGE_COLOR);

	bool startFlag;
	bool stopFlag;

	bool flag;

	cv::Mat cameraframe;
	cv::Mat edges;

	// namedWindow("edges",1);
		int count = 0;

		for(;;)
		{
			VideoCapture cap(0);

			cv::Mat frame;
			cap >> frame;

			imshow("cam", frame);
			if (waitKey(30) >= 0)
			{
				startFlag = detectGreen(cameraframe);
				stopFlag = detectRed(cameraframe);
				break;
			}

			if (flag > 0)
				flag = 1;
			cout << (flag) << endl;

			cap.release();

			//count++;
		}


	// while (true) {

	// 	stream.read(cameraframe);
	// 	imshow("cam", cameraframe);

	// 	if (waitKey(30) >= 0)
	// 	{
	// 		break;
	// 	}

	// 	sleep(1);

	// 	flag = detectGreen(cameraframe);

	// 	if (flag > 0)
	// 		flag = 1;
	// 	cout << (flag) << endl;
	// }

	if (startFlag && stopFlag)
		startFlag = 0;

	if (stopFlag)
		flag = 0;

	if (startFlag)
		flag = 1;

	// // communicating with Arduino
	/*FILE *file;
    file = fopen("/dev/ttyUSB0","w");  //Opening device file
    fprintf(file,"%d",flag); //Writing to the file
    fprintf(file,"%c",','); //To separate digits
    sleep(1);
    fclose(file);*/
}
