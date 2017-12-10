#include <boost/python.hpp>

struct Information
{
    void set(int msg) { this->msg = msg; }
    int get() { return msg; }
    int msg;
};

using namespace boost::python;
BOOST_PYTHON_MODULE(serial_ext)
{
    class_<Information>("Information")
        .def("get", &Information::get)
        .def("set", &Information::set)
    ;
}
