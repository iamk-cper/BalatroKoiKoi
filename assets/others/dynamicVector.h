#ifndef DYNAMICVECTOR_H
#define DYNAMICVECTOR_H

#include <initializer_list>
#include <memory>
#include <iostream>

template <typename T, std::size_t N>
class Vector;

template <typename T>
class Vector<T, 0> {
public:
    typedef T value_type;
    typedef std::size_t size_type;
    typedef T* pointer;
    typedef T& reference;
    typedef const T& const_reference;

private:
    std::unique_ptr<T[]> data_;
    size_type size_;

public:
    explicit Vector(size_type n)
            : data_(new T[n]), size_(n) {
        std::fill(data_.get(), data_.get() + size_, T{});
    }

    Vector(std::initializer_list<T> list)
            : data_(new T[list.size()]), size_(list.size()) {
        std::copy(list.begin(), list.end(), data_.get());
    }

    Vector(const Vector& other)
            : data_(new T[other.size_]), size_(other.size_) {
        std::copy(other.data_.get(), other.data_.get() + size_, data_.get());
    }

    Vector(Vector&& other) noexcept = default;

    Vector& operator=(const Vector& other) {
        if (this != &other) {
            std::unique_ptr<T[]> newData(new T[other.size_]);
            std::copy(other.data_.get(), other.data_.get() + other.size_, newData.get());
            data_ = std::move(newData);
            size_ = other.size_;
        }
        return *this;
    }

    Vector& operator=(Vector&&) noexcept = default;

    void resize(size_type newSize) {
        std::unique_ptr<T[]> newData(new T[newSize]);
        size_type toCopy = std::min(size_, newSize);
        std::copy(data_.get(), data_.get() + toCopy, newData.get());
        if (newSize > toCopy) {
            std::fill(newData.get() + toCopy, newData.get() + newSize, T{});
        }
        data_ = std::move(newData);
        size_ = newSize;
    }

    reference operator[](size_type idx) {
        return data_[idx];
    }
    const_reference operator[](size_type idx) const {
        return data_[idx];
    }

    size_type size() const {
        return size_;
    }

    friend Vector operator+(const Vector& u, const Vector& v) {
        Vector result(u.size_);
        for (size_type i = 0; i < u.size_; ++i) {
            result.data_[i] = u.data_[i] + v.data_[i];
        }
        return result;
    }

    friend std::ostream& operator<<(std::ostream& os, const Vector& v) {
        for (size_type i = 0; i < v.size_; ++i) {
            os << v.data_[i];
            if (i <= v.size_) os << ' ';
        }
        return os;
    }
};

#endif // DYNAMICVECTOR_H