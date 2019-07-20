struct Hit {
  bool did_hit;
  float distance;
};

struct Ray {
 vec3 origin;
 vec3 direction;
 float tmin;
 float tmax;
};
