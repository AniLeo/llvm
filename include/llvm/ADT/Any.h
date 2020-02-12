//===- Any.h - Generic type erased holder of any type -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//  This file provides Any, a non-template class modeled in the spirit of
//  std::any.  The idea is to provide a type-safe replacement for C's void*.
//  It can hold a value of any copy-constructible copy-assignable type
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_ADT_ANY_H
#define LLVM_ADT_ANY_H

#include "llvm/ADT/STLExtras.h"

#include <cassert>
#include <memory>
#include <type_traits>

namespace llvm {

class Any {
  template <typename T> struct TypeId { static const char Id; };

  struct StorageBase {
    virtual ~StorageBase() = default;
    virtual std::unique_ptr<StorageBase> clone() const = 0;
    virtual const void *id() const = 0;
  };

  template <typename T> struct StorageImpl : public StorageBase {
    explicit StorageImpl(const T &Value) : Value(Value) {}

    explicit StorageImpl(T &&Value) : Value(std::move(Value)) {}

    std::unique_ptr<StorageBase> clone() const override {
      return std::make_unique<StorageImpl<T>>(Value);
    }

    const void *id() const override { return &TypeId<T>::Id; }

    T Value;

  private:
    StorageImpl &operator=(const StorageImpl &Other) = delete;
    StorageImpl(const StorageImpl &Other) = delete;
  };

public:
  Any() = default;

  Any(const Any &Other)
      : Storage(Other.Storage ? Other.Storage->clone() : nullptr) {}

  // When T is Any or T is not copy-constructible we need to explicitly disable
  // the forwarding constructor so that the copy constructor gets selected
  // instead.
  template <typename T,
            std::enable_if_t<
                llvm::conjunction<
                    llvm::negation<std::is_same<std::decay_t<T>, Any>>,
                    // We also disable this overload when an `Any` object can be
                    // converted to the parameter type because in that case,
                    // this constructor may combine with that conversion during
                    // overload resolution for determining copy
                    // constructibility, and then when we try to determine copy
                    // constructibility below we may infinitely recurse. This is
                    // being evaluated by the standards committee as a potential
                    // DR in `std::any` as well, but we're going ahead and
                    // adopting it to work-around usage of `Any` with types that
                    // need to be implicitly convertible from an `Any`.
                    llvm::negation<std::is_convertible<Any, std::decay_t<T>>>,
                    std::is_copy_constructible<std::decay_t<T>>>::value,
                int> = 0>
  Any(T &&Value) {
    Storage =
        std::make_unique<StorageImpl<std::decay_t<T>>>(std::forward<T>(Value));
  }

  Any(Any &&Other) : Storage(std::move(Other.Storage)) {}

  Any &swap(Any &Other) {
    std::swap(Storage, Other.Storage);
    return *this;
  }

  Any &operator=(Any Other) {
    Storage = std::move(Other.Storage);
    return *this;
  }

  bool hasValue() const { return !!Storage; }

  void reset() { Storage.reset(); }

private:
  template <class T> friend T any_cast(const Any &Value);
  template <class T> friend T any_cast(Any &Value);
  template <class T> friend T any_cast(Any &&Value);
  template <class T> friend const T *any_cast(const Any *Value);
  template <class T> friend T *any_cast(Any *Value);
  template <typename T> friend bool any_isa(const Any &Value);

  std::unique_ptr<StorageBase> Storage;
};

template <typename T> const char Any::TypeId<T>::Id = 0;


template <typename T> bool any_isa(const Any &Value) {
  if (!Value.Storage)
    return false;
  return Value.Storage->id() ==
         &Any::TypeId<std::remove_cv_t<std::remove_reference_t<T>>>::Id;
}

template <class T> T any_cast(const Any &Value) {
  return static_cast<T>(
      *any_cast<std::remove_cv_t<std::remove_reference_t<T>>>(&Value));
}

template <class T> T any_cast(Any &Value) {
  return static_cast<T>(
      *any_cast<std::remove_cv_t<std::remove_reference_t<T>>>(&Value));
}

template <class T> T any_cast(Any &&Value) {
  return static_cast<T>(std::move(
      *any_cast<std::remove_cv_t<std::remove_reference_t<T>>>(&Value)));
}

template <class T> const T *any_cast(const Any *Value) {
  using U = std::remove_cv_t<std::remove_reference_t<T>>;
  assert(Value && any_isa<T>(*Value) && "Bad any cast!");
  if (!Value || !any_isa<U>(*Value))
    return nullptr;
  return &static_cast<Any::StorageImpl<U> &>(*Value->Storage).Value;
}

template <class T> T *any_cast(Any *Value) {
  using U = std::decay_t<T>;
  assert(Value && any_isa<U>(*Value) && "Bad any cast!");
  if (!Value || !any_isa<U>(*Value))
    return nullptr;
  return &static_cast<Any::StorageImpl<U> &>(*Value->Storage).Value;
}

} // end namespace llvm

#endif // LLVM_ADT_ANY_H
