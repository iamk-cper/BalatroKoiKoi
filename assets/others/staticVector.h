
#ifndef STATIC_VECTOR_H
#define STATIC_VECTOR_H


#include <memory>
#include <iostream>
#include <cassert>
#include <vector>
#include <cmath>

template <typename T, size_t N>
class Vector{
    T data[N];

public:
    typedef T value_type;
    typedef std::size_t  size_type;
    typedef T* pointer;
    typedef T& reference;
    typedef const T& const_reference;

    Vector() : data() {}
    Vector(const Vector & v) = default;
    Vector &operator=(const Vector & m) = default;
    Vector &operator=(Vector&&) noexcept = default;
    Vector(const std::initializer_list<T> &list) {
        size_type i = 0;
        for (const auto& val : list) {
            data[i++] = val;
            if (i == N) return;
        }
    }

    struct NoInitTag{};
    explicit Vector(NoInitTag) {}
    friend Vector operator+ (const  Vector & u, const Vector & v ){
        Vector result(NoInitTag{});
        for (size_type i = 0; i < N; ++i) {
            result.data[i] = u.data[i] + v.data[i];
        }
        return result;
    }

    constexpr size_type size() const {
        return N;
    }

    const_reference get(size_type index) const {
        return data[index];
    }

    void set(size_type index, const_reference value) {
        data[index] = value;
    }

    reference operator[](size_type index){
        return data[index];
    }
    const_reference operator[](size_type index) const{
        return data[index];
    }

    friend std::ostream &operator<<(std::ostream &out, const Vector & v) {
        for( auto elem: v.data ){
            out << elem << " ";
        }
        return out;
    }

};

#endif //STATIC_VECTOR_H