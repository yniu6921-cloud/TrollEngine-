#include <cstring>
#include <iostream>

struct Vec2 {
    float x, y;

    Vec2() { x = y = 0.0f; }

    Vec2(const float _x, const float _y) { x = _x; y = _y; }

    Vec2 operator+(const Vec2 &v) const { return {x + v.x, y + v.y}; }

    Vec2 operator-(const Vec2 &v) const { return {x - v.x, y - v.y}; }

    Vec2 operator*(const float &v) const { return {x * v, y * v}; }

    Vec2 operator/(const float &v) const { return {x / v, y / v}; }

    bool operator==(const Vec2 &v) const { return x == v.x && y == v.y; }

    bool operator!=(const Vec2 &v) const { return !(x == v.x && y == v.y); }

    static Vec2 Zero() { return {0.0f, 0.0f}; }

    static float Dot(const Vec2 lhs, const Vec2 rhs) { return lhs.x * rhs.x + lhs.y * rhs.y; }
};

struct Vec3 {
    float x,y,z;

    Vec3() { x = y = z = 0.0f; }

    Vec3(const float _x, const float _y, const float _z)  { x = _x; y = _y; z = _z; }

    Vec3 operator+(const Vec3 &v)  const  { return {x + v.x, y + v.y, z + v.z}; }

    Vec3 operator-(const Vec3 &v)  const  { return {x - v.x, y - v.y, z - v.z}; }

    Vec3 operator*(const float &v) const { return { x * v, y * v, z * v }; }

    Vec3 operator/(const float &v) const { return { x / v, y / v, z / v }; }

    bool operator==(const Vec3 &v) const { return x == v.x && y == v.y && z == v.z; }

    bool operator!=(const Vec3 &v) const { return !(x == v.x && y == v.y && z == v.z); }

    static Vec3 Zero() { return {0.0f, 0.0f, 0.0f}; }

    static float Dot(const Vec3 lhs, const Vec3 rhs) { return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z; }
};

struct D3DVector
{
    float X;
    float Y;
    float Z;
    D3DVector()
    {
        this->X = 0;
        this->Y = 0;
        this->Z = 0;
    }
    D3DVector(float x, float y, float z)
    {
        this->X = x;
        this->Y = y;
        this->Z = z;
    }
};

struct Rotator {
    float Pitch;
    float Yaw;
    float Roll;
    
    Rotator() : Pitch(0), Yaw(0), Roll(0) {}
    
    Rotator(float pitch, float yaw, float roll) : Pitch(pitch), Yaw(yaw), Roll(roll) {}
};