#include <opencv2/opencv.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/core/ocl.hpp>
#include <opencv2/tracking/tracker.hpp>
#include <opencv2/tracking/tldDataset.hpp>
 
using namespace cv;
using namespace std;

int main(int argc, const char** argv)
{
	Ptr<Tracker> tracker;

	tracker = TrackerMIL::create();

	VideoCapture video(0);

	if (!video.isOpened())
	{
		cout << "Camera opening failed" << endl;
	}

	cv::Mat frame;
	bool ok = video.read(frame);

	Rect2d bbox(200, 200, 200, 200);

	// Rect2d bbox = selectROI(frame, false);

	rectangle(frame, bbox, Scalar(255, 0, 0), 2, 1);
	imshow("Tracking", frame);

	tracker->init(frame, bbox);

	while(video.read(frame))
	{

		bool ok = tracker->update(frame, bbox);


		if (ok)
		{
			rectangle(frame, bbox, Scalar( 255, 0, 0 ), 2, 1 );
		}
		else
		{
			putText(frame, "Tracking failure detected", Point(100,80), FONT_HERSHEY_SIMPLEX, 0.75, Scalar(0,0,255),2);
		}

		imshow("Tracking", frame);
         
        if(waitKey(1) == 30)
        {
            break;
        }
	}


}