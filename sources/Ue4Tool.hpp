//
//  Ue4Tool.hpp
//  IOSPUBG
//
//  Created by yy on 2022/5/1.
//

#ifndef Ue4Tool_hpp
#define Ue4Tool_hpp

#include <stdio.h>
#include <string>
#include <math.h>

#include "OffsetsTool.hpp"
#include "StringObf.h"

using namespace std;

struct Vector2 {
    float X;
    float Y;
    
    // 默认构造函数
    Vector2() : X(0), Y(0) {}
    
    // 带参数的构造函数
    Vector2(float x, float y) : X(x), Y(y) {}
    
    // 返回零向量
    static Vector2 Zero() {
        return Vector2(0.0f, 0.0f);
    }
    
    // 计算两个向量之间的距离
    static float Distance(const Vector2& a, const Vector2& b) {
        Vector2 vector = Vector2(a.X - b.X, a.Y - b.Y);
        return std::sqrt((vector.X * vector.X) + (vector.Y * vector.Y));
    }
    
    // 重载 != 操作符
    bool operator!=(const Vector2 &src) const {
        return (src.X != X) || (src.Y != Y);
    }

    // 重载 + 操作符
    Vector2 operator+(const Vector2 &v) const {
        return Vector2(X + v.X, Y + v.Y);
    }
    
    // 重载 - 操作符
    Vector2 operator-(const Vector2 &v) const {
        return Vector2(X - v.X, Y - v.Y);
    }
    
    // 重载 / 操作符
    Vector2 operator/(const float A) const {
        return Vector2(this->X / A, this->Y / A);
    }
    
    // 重载 += 操作符
    Vector2& operator+=(const Vector2 &v) {
        X += v.X;
        Y += v.Y;
        return *this;
    }

    // 重载 * 操作符
    Vector2 operator*(float a) const {
        return Vector2(X * a, Y * a);
    }
    
    // 重载 -= 操作符
    Vector2& operator-=(const Vector2 &v) {
        X -= v.X;
        Y -= v.Y;
        return *this;
    }
    
    // 计算向量的大小（模）
    float Size() const {
        return std::sqrt((this->X * this->X) + (this->Y * this->Y));
    }

    // 标准化向量
    Vector2 Normalize() const {
        float size = this->Size();
        if (size == 0) return Vector2::Zero(); // 防止除以0
        return *this / size;
    }
    
    // 根据屏幕大小标准化向量
    Vector2 NormalizeToScreenSize(float screenWidth, float screenHeight) const {
        return Vector2(X / screenWidth, Y / screenHeight);
    }

    // 翻转Y坐标
    Vector2 FlipY(float screenHeight) const {
        return Vector2(X, screenHeight - Y);
    }
};

struct Vector3 {
    float X;
    float Y;
    float Z;

    Vector3() {
        this->X = 0;
        this->Y = 0;
        this->Z = 0;
    }

    Vector3(float x, float y, float z) {
        this->X = x;
        this->Y = y;
        this->Z = z;
    }
    float Size ();
    Vector3 operator+(const Vector3 &v) const {
        return Vector3(X + v.X, Y + v.Y, Z + v.Z);
    }

    Vector3 operator-(const Vector3 &v) const {
        return Vector3(X - v.X, Y - v.Y, Z - v.Z);
    }

    bool operator==(const Vector3 &v) {
        return X == v.X && Y == v.Y && Z == v.Z;
    }

    bool operator!=(const Vector3 &v) {
        return !(X == v.X && Y == v.Y && Z == v.Z);
    }
    Vector3 operator-= (const Vector3 &A) {
        this->X -= A.X;
        this->Y -= A.Y;
        this->Z -= A.Z;
        return *this;
    }
    
    Vector3 operator-= (const float A) {
        this->X -= A;
        this->Y -= A;
        this->Z -= A;
        return *this;
    }
    
    Vector3 operator/ (const float A) {
        return Vector3(this->X/A, this->Y/A, this->Z/A);
    }
    static Vector3 Zero() {
        return Vector3(0.0f, 0.0f, 0.0f);
    }
    
    static float Dot(Vector3 a, Vector3 b) {
        return a.X * b.X + a.Y * b.Y + a.Z * b.Z;
    }
    Vector3 operator*(float a) {
        return Vector3(X * a, Y * a, Z * a);
    }
    
    static float Distance(Vector3 a, Vector3 b) {
        Vector3 vector = Vector3(a.X - b.X, a.Y - b.Y, a.Z - b.Z);
        return sqrt(vector.X * vector.X + vector.Y * vector.Y + vector.Z * vector.Z);
    }
};
float Vector3::Size ()
{
    return sqrt( ( this->X * this->X ) + ( this->Y * this->Y ) + ( this->Z * this->Z ) );
}

struct Vector4 {
    float x;
    float y;
    float z;
    float w;
};

struct VectorRect {
    int x;
    int y;
    int w;
    int h;
};

typedef struct FVectorRect {
    float X;
    float Y;
    float W;
    float H;
} FVectorRect;



struct FMatrix {
    float Matrix[4][4];

    float *operator[](int index) {
        return Matrix[index];
    }
};

struct FTransform {
    Vector4 Rotation;
    Vector3 Translation;
    Vector3 Scale3D;
};

struct FRotator {
    float Pitch;
    float Yaw;
    float Roll;
};

struct CoViewbyo {
    Vector3 Location;
    Vector3 LocationLocalSpace;
    FRotator Rotation;
    char ViewTag[0xC];//0xC
    float FOV;               // 现在FOV的偏移量变为0x2C (紧随ViewTag之后)
  
};


struct D3DXMATRIX {
    float _11, _12, _13, _14;
    float _21, _22, _23, _24;
    float _31, _32, _33, _34;
    float _41, _42, _43, _44;
};

struct ObjectName {
    const char data[64];
};

#pragma mark - 坐标系转换

//static Vector3 Zero() {
//    return Vector3(0.0f, 0.0f, 0.0f);
//}

static float Dot(Vector3 lhs, Vector3 rhs) {
    return (((lhs.X * rhs.X) + (lhs.Y * rhs.Y)) + (lhs.Z * rhs.Z));
}

static float GetDistance(Vector3 a, Vector3 b) {
    Vector3 vector = Vector3(a.X - b.X, a.Y - b.Y, a.Z - b.Z);
    return sqrt(((vector.X * vector.X) + (vector.Y * vector.Y)) + (vector.Z * vector.Z));
}

static Vector3 MatrixToVector(FMatrix matrix) {
    return Vector3(matrix[3][0], matrix[3][1], matrix[3][2]);
}

static FMatrix MatrixMulti(FMatrix m1, FMatrix m2) {
    FMatrix matrix = FMatrix();
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            for (int k = 0; k < 4; k++) {
                matrix[i][j] += m1[i][k] * m2[k][j];
            }
        }
    }
    return matrix;
}

static FMatrix TransformToMatrix(FTransform transform) {
    FMatrix matrix;
    
    matrix[3][0] = transform.Translation.X;
    matrix[3][1] = transform.Translation.Y;
    matrix[3][2] = transform.Translation.Z;
    
    float x2 = transform.Rotation.x + transform.Rotation.x;
    float y2 = transform.Rotation.y + transform.Rotation.y;
    float z2 = transform.Rotation.z + transform.Rotation.z;
    
    float xx2 = transform.Rotation.x * x2;
    float yy2 = transform.Rotation.y * y2;
    float zz2 = transform.Rotation.z * z2;
    
    matrix[0][0] = (1.0f - (yy2 + zz2)) * transform.Scale3D.X;
    matrix[1][1] = (1.0f - (xx2 + zz2)) * transform.Scale3D.Y;
    matrix[2][2] = (1.0f - (xx2 + yy2)) * transform.Scale3D.Z;
    
    float yz2 = transform.Rotation.y * z2;
    float wx2 = transform.Rotation.w * x2;
    matrix[2][1] = (yz2 - wx2) * transform.Scale3D.Z;
    matrix[1][2] = (yz2 + wx2) * transform.Scale3D.Y;
    
    float xy2 = transform.Rotation.x * y2;
    float wz2 = transform.Rotation.w * z2;
    matrix[1][0] = (xy2 - wz2) * transform.Scale3D.Y;
    matrix[0][1] = (xy2 + wz2) * transform.Scale3D.X;
    
    float xz2 = transform.Rotation.x * z2;
    float wy2 = transform.Rotation.w * y2;
    matrix[2][0] = (xz2 + wy2) * transform.Scale3D.Z;
    matrix[0][2] = (xz2 - wy2) * transform.Scale3D.X;
    
    matrix[0][3] = 0;
    matrix[1][3] = 0;
    matrix[2][3] = 0;
    matrix[3][3] = 1;
    
    return matrix;
}

static FMatrix RotatorToMatrix(FRotator rotation) {
    float radPitch = rotation.Pitch * ((float) M_PI / 180.0f);
    float radYaw = rotation.Yaw * ((float) M_PI / 180.0f);
    float radRoll = rotation.Roll * ((float) M_PI / 180.0f);
    
    float SP = sinf(radPitch);
    float CP = cosf(radPitch);
    float SY = sinf(radYaw);
    float CY = cosf(radYaw);
    float SR = sinf(radRoll);
    float CR = cosf(radRoll);
    
    FMatrix matrix;
    
    matrix[0][0] = (CP * CY);
    matrix[0][1] = (CP * SY);
    matrix[0][2] = (SP);
    matrix[0][3] = 0;
    
    matrix[1][0] = (SR * SP * CY - CR * SY);
    matrix[1][1] = (SR * SP * SY + CR * CY);
    matrix[1][2] = (-SR * CP);
    matrix[1][3] = 0;
    
    matrix[2][0] = (-(CR * SP * CY + SR * SY));
    matrix[2][1] = (CY * SR - CR * SP * SY);
    matrix[2][2] = (CR * CP);
    matrix[2][3] = 0;
    
    matrix[3][0] = 0;
    matrix[3][1] = 0;
    matrix[3][2] = 0;
    matrix[3][3] = 1;
    
    return matrix;
}

static Vector2 WorldToScreen(Vector3 worldLocation, CoViewbyo camViewInfo, int width, int height) {
    // 提前计算并存储常量
    float fovRadian = camViewInfo.FOV * ((float) M_PI / 360.0f);
    float tanFov = tanf(fovRadian);
    const float screenCenterX = (width / 2.0f);
    const float screenCenterY = (height / 2.0f);

    // 旋转矩阵
    FMatrix tempMatrix = RotatorToMatrix(camViewInfo.Rotation);
    
    Vector3 vAxisX(tempMatrix[0][0], tempMatrix[0][1], tempMatrix[0][2]);
    Vector3 vAxisY(tempMatrix[1][0], tempMatrix[1][1], tempMatrix[1][2]);
    Vector3 vAxisZ(tempMatrix[2][0], tempMatrix[2][1], tempMatrix[2][2]);
    
    Vector3 vDelta = worldLocation - camViewInfo.Location;

    // 转换到摄像机空间
    float transformedX = Dot(vDelta, vAxisY);
    float transformedY = Dot(vDelta, vAxisZ);
    float transformedZ = Dot(vDelta, vAxisX);

    // 处理Z值避免精度问题
    if (transformedZ < 1.0f) {
        transformedZ = 1.0f;  // 根据需要修改
    }

    // 计算屏幕坐标
    return Vector2(
        (screenCenterX + transformedX * (screenCenterX / tanFov) / transformedZ),
        (screenCenterY - transformedY * (screenCenterX / tanFov) / transformedZ)
    );
}


static VectorRect BoxConversion(Vector3 worldLocation, CoViewbyo camViewInfo, int width, int height) {
    Vector3 Location = worldLocation;
    Location.Z += 90.f;
    
    Vector2 calculate = WorldToScreen(worldLocation, camViewInfo, width, height);
    Vector2 calculat2 = WorldToScreen(Location, camViewInfo, width, height);
    
    VectorRect rectangle;
    rectangle.h = calculate.Y - calculat2.Y;
    rectangle.w = rectangle.h / 2.5;
    rectangle.x = calculate.X - rectangle.w;
    rectangle.y = calculat2.Y;
    rectangle.w = rectangle.w * 2;
    rectangle.h = rectangle.h * 2;
    
    return rectangle;
}

static void BoxConversion(Vector3 worldLocation, VectorRect *rect, CoViewbyo camViewInfo, Vector2 CanvasSize) {
    Vector3 worldLocation2 = worldLocation;
    worldLocation2.Z += 90.f;
    
    Vector2 calculate = WorldToScreen(worldLocation, camViewInfo, CanvasSize.X, CanvasSize.Y);
    Vector2 calculate2 = WorldToScreen(worldLocation2, camViewInfo, CanvasSize.X, CanvasSize.Y);
    
    rect->h = calculate.Y - calculate2.Y;
    rect->w = rect->h / 2.5;
    rect->x = calculate.X - rect->w;
    rect->y = calculate2.Y;
    rect->w = rect->w * 2;
    rect->h = rect->h * 2;
}

static bool isScreenVisible(Vector2 LocationScreen, Vector2 CanvasSize) {
    if (LocationScreen.X > 0 && LocationScreen.X < CanvasSize.X &&
        LocationScreen.Y > 0 && LocationScreen.Y < CanvasSize.Y) return true;
    else return false;
}
static bool isEqual(string s1, const char* check) {
    string s2(check);
    return (s1 == s2);
}

static bool GetInsideFov(float ScreenWidth, float ScreenHeight, Vector2 PlayerBone, float FovRadius) {
    Vector2 Cenpoint;
    Cenpoint.X = PlayerBone.X - (ScreenWidth / 2);
    Cenpoint.Y = PlayerBone.Y - (ScreenHeight / 2);
    if (Cenpoint.X * Cenpoint.X + Cenpoint.Y * Cenpoint.Y <= FovRadius * FovRadius) return true;
    return false;
}

static int GetCenterOffsetForVector(Vector2 point, Vector2 CanvasSize) {
    return sqrt(pow(point.X - CanvasSize.X/2, 2.0) + pow(point.Y - CanvasSize.Y/2, 2.0));
}

static D3DXMATRIX ToMatrixWithScale(Vector4 rotation, Vector3 translation, Vector3 scale3D) {
    D3DXMATRIX ret;
    float x2, y2, z2, xx2, yy2, zz2, yz2, wx2, xy2, wz2, xz2, wy2 = 0.f;
    ret._41 = translation.X;
    ret._42 = translation.Y;
    ret._43 = translation.Z;
    
    x2 = rotation.x * 2;
    y2 = rotation.y * 2;
    z2 = rotation.z * 2;
    
    xx2 = rotation.x * x2;
    yy2 = rotation.y * y2;
    zz2 = rotation.z * z2;
    
    ret._11 = (1 - (yy2 + zz2)) * scale3D.X;
    ret._22 = (1 - (xx2 + zz2)) * scale3D.Y;
    ret._33 = (1 - (xx2 + yy2)) * scale3D.Z;
    
    yz2 = rotation.y * z2;
    wx2 = rotation.w * x2;
    ret._32 = (yz2 - wx2) * scale3D.Z;
    ret._23 = (yz2 + wx2) * scale3D.Y;
    
    xy2 = rotation.x * y2;
    wz2 = rotation.w * z2;
    ret._21 = (xy2 - wz2) * scale3D.Y;
    ret._12 = (xy2 + wz2) * scale3D.X;
    
    xz2 = rotation.x * z2;
    wy2 = rotation.w * y2;
    ret._31 = (xz2 + wy2) * scale3D.Z;
    ret._13 = (xz2 - wy2) * scale3D.X;
    
    ret._14 = 0.f;
    ret._24 = 0.f;
    ret._34 = 0.f;
    ret._44 = 1.f;
    
    return ret;
}

static D3DXMATRIX MatrixMultiplication(D3DXMATRIX M1, D3DXMATRIX M2) {
    D3DXMATRIX ret;
    ret._11 = M1._11 * M2._11 + M1._12 * M2._21 + M1._13 * M2._31 + M1._14 * M2._41;
    ret._12 = M1._11 * M2._12 + M1._12 * M2._22 + M1._13 * M2._32 + M1._14 * M2._42;
    ret._13 = M1._11 * M2._13 + M1._12 * M2._23 + M1._13 * M2._33 + M1._14 * M2._43;
    ret._14 = M1._11 * M2._14 + M1._12 * M2._24 + M1._13 * M2._34 + M1._14 * M2._44;
    ret._21 = M1._21 * M2._11 + M1._22 * M2._21 + M1._23 * M2._31 + M1._24 * M2._41;
    ret._22 = M1._21 * M2._12 + M1._22 * M2._22 + M1._23 * M2._32 + M1._24 * M2._42;
    ret._23 = M1._21 * M2._13 + M1._22 * M2._23 + M1._23 * M2._33 + M1._24 * M2._43;
    ret._24 = M1._21 * M2._14 + M1._22 * M2._24 + M1._23 * M2._34 + M1._24 * M2._44;
    ret._31 = M1._31 * M2._11 + M1._32 * M2._21 + M1._33 * M2._31 + M1._34 * M2._41;
    ret._32 = M1._31 * M2._12 + M1._32 * M2._22 + M1._33 * M2._32 + M1._34 * M2._42;
    ret._33 = M1._31 * M2._13 + M1._32 * M2._23 + M1._33 * M2._33 + M1._34 * M2._43;
    ret._34 = M1._31 * M2._14 + M1._32 * M2._24 + M1._33 * M2._34 + M1._34 * M2._44;
    ret._41 = M1._41 * M2._11 + M1._42 * M2._21 + M1._43 * M2._31 + M1._44 * M2._41;
    ret._42 = M1._41 * M2._12 + M1._42 * M2._22 + M1._43 * M2._32 + M1._44 * M2._42;
    ret._43 = M1._41 * M2._13 + M1._42 * M2._23 + M1._43 * M2._33 + M1._44 * M2._43;
    ret._44 = M1._41 * M2._14 + M1._42 * M2._24 + M1._43 * M2._34 + M1._44 * M2._44;
    return ret;
}

static FRotator CalcAngle(Vector3 aimPos) {
    float hyp = sqrt(aimPos.X * aimPos.X + aimPos.Y * aimPos.Y + aimPos.Z * aimPos.Z);
    float Yaw =  atan2(aimPos.Y, aimPos.X) * 180 / M_PI;
    float Pitch = asin(aimPos.Z / hyp) * 180 / M_PI;
    FRotator aimRotation = {Pitch, Yaw, 0};
    return aimRotation;
}

static float change(float num) {
    if (num < 0) {
        return abs(num);
    } else if (num > 0) {
        return num - num * 2;
    }
    return num;
}

static float getAngleDifference(float angle1, float angle2) {
    float diff = fmod(angle2 - angle1 + 180, 360) - 180;
    return diff < -180 ? diff + 360 : diff;
}

#pragma mark - 游戏数据



typedef struct FVector3D {
    float X;
    float Y;
    float Z;
} FVector3D;
typedef struct FVector2D {
    float X;
    float Y;
} FVector2D;


D3DXMATRIX toMATRIX(FRotator rot){
    float RadPitch, RadYaw, RadRoll, SP, CP, SY, CY, SR, CR;
    D3DXMATRIX M;
    
    RadPitch = rot.Pitch * M_PI / 180;
    RadYaw = rot.Yaw * M_PI / 180;
    RadRoll = rot.Roll * M_PI / 180;
    
    SP = sin(RadPitch);
    CP = cos(RadPitch);
    SY = sin(RadYaw);
    CY = cos(RadYaw);
    SR = sin(RadRoll);
    CR = cos(RadRoll);
    
    M._11 = CP * CY;
    M._12 = CP * SY;
    M._13 = SP;
    M._14 = 0.f;
    
    M._21 = SR * SP * CY - CR * SY;
    M._22 = SR * SP * SY + CR * CY;
    M._23 = -SR * CP;
    M._24 = 0.f;
    
    M._31 = -(CR * SP * CY + SR * SY);
    M._32 = CY * SR - CR * SP * SY;
    M._33 = CR * CP;
    M._34 = 0.f;
    
    M._41 = 0.f;
    M._42 = 0.f;
    M._43 = 0.f;
    M._44 = 1.f;
    
    return M;
}
FVector3D minusTheVector(FVector3D first,FVector3D second){
    FVector3D ret;
    ret.X = first.X - second.X;
    ret.Y = first.Y - second.Y;
    ret.Z = first.Z - second.Z;
    return ret;
}
void getTheAxes(FRotator rot,FVector3D *x,FVector3D *y, FVector3D *z){
    D3DXMATRIX M = toMATRIX(rot);
    
    x->X = M._11;
    x->Y = M._12;
    x->Z = M._13;
    
    y->X = M._21;
    y->Y = M._22;
    y->Z = M._23;
    
    z->X = M._31;
    z->Y = M._32;
    z->Z = M._33;
}


static bool worldToScreenForRect(Vector3 Pos ,CoViewbyo camViewInfo,Vector2 canvas, FVectorRect *outRect){
    Vector3 Pos2 = Pos;
    Pos2.Z += 90.f;
    
    Vector2 CalcPos = WorldToScreen(Pos, camViewInfo, canvas.X,  canvas.Y);
    Vector2 CalcPos2 = WorldToScreen(Pos2, camViewInfo, canvas.X,  canvas.Y);
   
    outRect->H = CalcPos.Y - CalcPos2.Y;
    outRect->W = outRect->H / 2.5;
    outRect->X = CalcPos.X - outRect->W;
    outRect->Y = CalcPos2.Y;
    outRect->W = outRect->W * 2;
    outRect->H = outRect->H * 2;
    
    return YES;
}
struct ImVec3
{
    float                                           x, y, z;
    ImVec3()                                        { x = y = z = 0.0f; }
    ImVec3(float _x, float _y, float _z)  { x = _x; y = _y; z = _z; }
    
    ImVec3 operator+(const ImVec3 &v) const {
        return ImVec3(x + v.x, y + v.y, z + v.z);
    }
    
    ImVec3 operator-(const ImVec3 &v) const {
        return ImVec3(x - v.x, y - v.y, z - v.z);
    }
    
    bool operator==(const ImVec3 &v) {
        return x == v.x && y == v.y && z == v.z;
    }
    
    bool operator!=(const ImVec3 &v) {
        return !(x == v.x && y == v.y && z == v.z);
    }
    
    static ImVec3 Zero() {
        return ImVec3(0.0f, 0.0f, 0.0f);
    }
    
    static float Dot(ImVec3 lhs, ImVec3 rhs) {
        return (((lhs.x * rhs.x) + (lhs.y * rhs.y)) + (lhs.z * rhs.z));
    }
    
    static float Distance(ImVec3 a, ImVec3 b) {
        ImVec3 vector = ImVec3(a.x - b.x, a.y - b.y, a.z - b.z);
        return sqrt(((vector.x * vector.x) + (vector.y * vector.y)) + (vector.z * vector.z));
    }
};
static string PickUpDataName(int goodsListId) {
    switch (goodsListId) {
        case 601006: return OBF_STR("[药品]医疗箱"); break;
        case 601004: return OBF_STR("[药品]绷带"); break;
        case 601005: return OBF_STR("[药品]急救包"); break;
        case 601001: return OBF_STR("[药品]能量饮料"); break;
        case 601002: return OBF_STR("[药品]肾上腺素"); break;
        case 601003: return OBF_STR("[药品]止痛药"); break;
       
        case 503003: return OBF_STR("[护甲]三级甲"); break;
        case 501003: return OBF_STR("[背包]三级包"); break;
        case 502003: return OBF_STR("[头盔]三级头"); break;
        case 501006: return OBF_STR("[背包]三级包"); break;
        case 501009: return OBF_STR("[背包]三级包"); break;
        case 501012: return OBF_STR("[背包]三级包"); break;
        case 501015: return OBF_STR("[背包]三级包"); break;
        case 501104: return OBF_STR("[背包]四级包"); break;
        case 501105: return OBF_STR("[背包]五级包"); break;
        case 501106: return OBF_STR("[背包]六级包"); break;
        case 502104: return OBF_STR("[头盔]四级头"); break;
        case 502105: return OBF_STR("[头盔]五级头"); break;
        case 502106: return OBF_STR("[头盔]六级头"); break;
        case 502107: return OBF_STR("[头盔]四级头(独眼蛇)"); break;
        case 502108: return OBF_STR("[头盔]五级头(独眼蛇)"); break;
        case 502109: return OBF_STR("[头盔]六级头(独眼蛇)"); break;
        case 502110: return OBF_STR("[头盔]四级头(钢铁阵线)"); break;
        case 502111: return OBF_STR("[头盔]五级头(钢铁阵线)"); break;
        case 502112: return OBF_STR("[头盔]六级头(钢铁阵线)"); break;
        case 503104: return OBF_STR("[护甲]四级甲"); break;
        case 503105: return OBF_STR("[护甲]五级甲"); break;
        case 503106: return OBF_STR("[护甲]六级甲"); break;
        case 503107: return OBF_STR("[护甲]四级甲(独眼蛇)"); break;
        case 503108: return OBF_STR("[护甲]五级甲(独眼蛇)"); break;
        case 503109: return OBF_STR("[护甲]六级甲(独眼蛇)"); break;
        case 503110: return OBF_STR("[护甲]四级甲(钢铁阵线)"); break;
        case 503111: return OBF_STR("[护甲]五级甲(钢铁阵线)"); break;
        case 503112: return OBF_STR("[护甲]六级甲(钢铁阵线)"); break;
        case 503113: return OBF_STR("[护甲]一级甲(强化型)"); break;
        case 503114: return OBF_STR("[护甲]二级甲(强化型)"); break;
        case 503115: return OBF_STR("[护甲]三级甲(强化型)"); break;
        
        case 103001: return OBF_STR("[狙击]Kar98k"); break;
        case 103002: return OBF_STR("[狙击]M24"); break;
        case 103003: return OBF_STR("[狙击]AWM"); break;
        case 1030034: return OBF_STR("[狙击]AWM改进"); break;
        case 1030035: return OBF_STR("[狙击]AWM精制"); break;
        case 1030036: return OBF_STR("[狙击]AWM独眼蛇"); break;
        case 1030037: return OBF_STR("[狙击]AWM钢铁阵线"); break;
        case 103004: return OBF_STR("[狙击]SKS"); break;
        case 103005: return OBF_STR("[狙击]VSS"); break;
        case 103006: return OBF_STR("[狙击]Mini14"); break;
        case 1030061: return OBF_STR("[狙击]Mini14"); break;
        case 103007: return OBF_STR("[狙击]MK14"); break;
        case 1030074: return OBF_STR("[狙击]MK14改进"); break;
        case 1030075: return OBF_STR("[狙击]MK14精制"); break;
        case 1030076: return OBF_STR("[狙击]MK14独眼蛇"); break;
        case 1030077: return OBF_STR("[狙击]MK14钢铁阵线"); break;
        case 1010091: return OBF_STR("[狙击]MK47"); break;
        case 103008: return OBF_STR("[狙击]Win94"); break;
        case 1030081: return OBF_STR("[狙击]Win94"); break;
        case 103009: return OBF_STR("[狙击]SLR"); break;
        case 103010: return OBF_STR("[狙击]QBU"); break;
        case 103011: return OBF_STR("[狙击]Mosinagan"); break;
        case 103012: return OBF_STR("[狙击]AMR"); break;
        case 103100: return OBF_STR("[狙击]Mk12"); break;
            
        case 101001: return OBF_STR("[步枪]AKM"); break;
        case 1010011: return OBF_STR("[步枪]AKM（破损）"); break;
        case 1010012: return OBF_STR("[步枪]AKM（修复）"); break;
        case 101002: return OBF_STR("[步枪]M16A4"); break;
        case 1010021: return OBF_STR("[步枪]M16A4"); break;
        case 101003: return OBF_STR("[步枪]SCAR"); break;
        case 101004: return OBF_STR("[步枪]M416"); break;
        case 1010043: return OBF_STR("[步枪]M416"); break;
        case 101005: return OBF_STR("[步枪]Groza"); break;
        case 1010053: return OBF_STR("[步枪]Groza"); break;
        case 1010054: return OBF_STR("[步枪]Groza改进"); break;
        case 1010055: return OBF_STR("[步枪]Groza精制"); break;
        case 1010056: return OBF_STR("[步枪]Groza独眼蛇"); break;
        case 1010057: return OBF_STR("[步枪]Groza钢铁阵线"); break;
        case 101006: return OBF_STR("[步枪]AUG"); break;
        case 101007: return OBF_STR("[步枪]QBZ"); break;
        case 101008: return OBF_STR("[步枪]M762"); break;
        case 101009: return OBF_STR("[步枪]Mk47"); break;
        case 101010: return OBF_STR("[步枪]G36C"); break;
        case 101011: return OBF_STR("[步枪]AC-VA"); break;
        case 101012: return OBF_STR("[步枪]蜜獾自动步枪"); break;
        case 101100: return OBF_STR("[步枪]FAMAS"); break;
        case 101101: return OBF_STR("[步枪]ASM Abakan"); break;
            
        case 105001: return OBF_STR("[机枪]M249"); break;
        case 1050013: return OBF_STR("[机枪]M249"); break;
        case 105002: return OBF_STR("[机枪]DP28"); break;
        case 105003: return OBF_STR("[机枪]MG3"); break;
        case 105010: return OBF_STR("[机枪]MG3"); break;
        case 1050104: return OBF_STR("[机枪]MG3改进"); break;
        case 1050105: return OBF_STR("[机枪]MG3精制"); break;
        case 1050106: return OBF_STR("[机枪]MG3独眼蛇"); break;
        case 1050107: return OBF_STR("[机枪]MG3钢铁阵线"); break;

        case 403045: return OBF_STR("吉利服"); break;
        case 403038: return OBF_STR("吉利服"); break;
        case 403025: return OBF_STR("吉利服"); break;

        case 106007: return OBF_STR("信号枪"); break;
            
        case 303001: return OBF_STR("[弹药]5.56mm"); break;
        case 302001: return OBF_STR("[弹药]7.62mm"); break;
        case 306001: return OBF_STR("[弹药]马格南"); break;
        case 308001: return OBF_STR("[弹药]信号弹"); break;
        case 306002: return OBF_STR("[弹药].50口径"); break;
            
        case 203001: return OBF_STR("[倍镜]红点"); break;
        case 203002: return OBF_STR("[倍镜]全息"); break;
        case 203003: return OBF_STR("[倍镜]二倍镜"); break;
        case 203014: return OBF_STR("[倍镜]三倍镜"); break;
        case 203004: return OBF_STR("[倍镜]四倍镜"); break;
        case 203015: return OBF_STR("[倍镜]六倍镜"); break;
        case 203005: return OBF_STR("[倍镜]八倍镜"); break;
        
        case 201007: return OBF_STR("[配件]消音器(狙击)"); break;
        case 204009: return OBF_STR("[配件]快速扩容(狙击)"); break;
        case 204007: return OBF_STR("[配件]扩容(狙击)"); break;
        case 201011: return OBF_STR("[配件]消音器(步枪)"); break;
        case 204013: return OBF_STR("[配件]快速扩容(步枪)"); break;
        case 204011: return OBF_STR("[配件]扩容(步枪)"); break;
        case 204012: return OBF_STR("[配件]快速弹匣(步枪)"); break;
            
        case 602004: return OBF_STR("[投掷物]手雷"); break;
        case 602002: return OBF_STR("[投掷物]烟雾弹"); break;
        case 602003: return OBF_STR("[投掷物]燃烧瓶"); break;
        case 602001: return OBF_STR("[投掷物]震爆弹"); break;
        case 602075: return OBF_STR("[投掷物]铝热弹"); break;
            
        case 108002: return OBF_STR("[近战]撬棍"); break;
        case 108004: return OBF_STR("[近战]平底锅"); break;
        case 108003: return OBF_STR("[近战]镰刀"); break;
        case 108001: return OBF_STR("[近战]大砍刀"); break;
        case 108024: return OBF_STR("[近战]伸缩钩索"); break;
            
            
        case 1000: return OBF_STR("金币"); break;
        case 3001028: return OBF_STR("现金盒"); break;
        case 3001029: return OBF_STR("零件包"); break;
        case 3001030: return OBF_STR("科技部件"); break;
        case 3001031: return OBF_STR("密码信函（白）"); break;
        case 3001032: return OBF_STR("狗牌"); break;
        case 3001033: return OBF_STR("信号发生器"); break;
        case 3001034: return OBF_STR("燃气瓶"); break;
        case 3001035: return OBF_STR("精密仪器蓝图"); break;
        case 3001036: return OBF_STR("指南针"); break;
        case 3001037: return OBF_STR("明信片"); break;
        case 3001038: return OBF_STR("探测器"); break;
        case 3001039: return OBF_STR("旧式录像带"); break;
        case 3001040: return OBF_STR("Mountain Dew"); break;
        case 3001041: return OBF_STR("The Album"); break;
        case 3001042: return OBF_STR("密码信函（红）"); break;
        case 3001043: return OBF_STR("密码信函（黄）"); break;
        case 3001044: return OBF_STR("密码信函（绿）"); break;
        case 3001045: return OBF_STR("密码信函（黑）"); break;
        case 3001046: return OBF_STR("扑克牌"); break;
        case 3001047: return OBF_STR("军用水壶"); break;
        case 3001048: return OBF_STR("罐头"); break;
        case 3001049: return OBF_STR("净水器"); break;
        case 3001050: return OBF_STR("润滑油"); break;
        case 3001051: return OBF_STR("汽车钥匙"); break;
        case 3001052: return OBF_STR("杂志"); break;
        case 3001053: return OBF_STR("平板电脑"); break;
        case 3001054: return OBF_STR("一根金条"); break;
        case 3001055: return OBF_STR("CPU处理器"); break;
        case 3001056: return OBF_STR("柴油"); break;
        case 3001057: return OBF_STR("机油"); break;
        case 3001058: return OBF_STR("狗牌-独眼蛇"); break;
        case 3001059: return OBF_STR("狗牌-钢铁阵线"); break;
        case 3001060: return OBF_STR("军功"); break;
        case 3001061: return OBF_STR("功勋奖章（铜）"); break;
        case 3001062: return OBF_STR("功勋奖章（银）"); break;
        case 3001063: return OBF_STR("功勋奖章（金）"); break;
        case 3001064: return OBF_STR("生物样本"); break;
        case 3001065: return OBF_STR("GPU处理器"); break;
        case 3001066: return OBF_STR("镜头"); break;
        case 3001067: return OBF_STR("一块金砖"); break;
        case 3001068: return OBF_STR("鼓鼓的现金盒"); break;
        case 3001101: return OBF_STR("便携手札"); break;
        case 3001102: return OBF_STR("小钱箱"); break;
        case 3001103: return OBF_STR("怀表"); break;
        case 3001104: return OBF_STR("便携展示柜"); break;
        case 3001105: return OBF_STR("粉色左轮"); break;
        case 3001106: return OBF_STR("防震耳机"); break;
        case 3001107: return OBF_STR("怡神精油"); break;
        case 3001108: return OBF_STR("旅行手册"); break;
        case 3001109: return OBF_STR("军用手表"); break;
        case 3001110: return OBF_STR("玩具匕首"); break;
        case 3001111: return OBF_STR("爱心项链"); break;
        case 3001112: return OBF_STR("崭新军靴"); break;
        case 3001113: return OBF_STR("笔记本"); break;
        case 3001114: return OBF_STR("破损的地图"); break;
        case 3001115: return OBF_STR("破损的设计图纸"); break;
        case 3006001: return OBF_STR("纳米晶体"); break;
        case 3006002: return OBF_STR("动力装甲蓝图"); break;
        case 3006007: return OBF_STR("身份卡"); break;
        
        case 3020014: return OBF_STR("7.62毫米子弹（高爆）"); break;
        case 3020015: return OBF_STR("7.62毫米子弹（燃烧）"); break;
        case 3020016: return OBF_STR("7.62毫米子弹（毒性）"); break;
        
        case 3030014: return OBF_STR("5.56毫米子弹（高爆）"); break;
        case 3030015: return OBF_STR("5.56毫米子弹（燃烧）"); break;
        case 3030016: return OBF_STR("5.56毫米子弹（毒性）"); break;
            
        default: return OBF_STR("Error"); break;
    }
}

//using FunctionPtr = bool(__fastcall *)(kaddr, kaddr, Vector3*, bool);
//FunctionPtr funcPtr = reinterpret_cast<FunctionPtr>(读取大坐标(Offsets::LineOfSightTo_Func));
//
//void* voidPtr = reinterpret_cast<void*>(funcPtr);
//// 将 void* 指针转换回原始类型
//bool(__fastcall *normalPtr)(kaddr, kaddr, Vector3*, bool) = reinterpret_cast<bool(__fastcall *)(kaddr, kaddr, Vector3*, bool)>(voidPtr);
//
//// 使用正常的函数指针进行调用
//bool result = normalPtr(localPlayerController, self.localPlayer.base, &viewPoint, false);



#endif /* Ue4Tool_hpp */
