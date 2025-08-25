#pragma once

#include <string>
#include <string_view>

namespace hello_service {

enum class UserType { kFirstTime, kKnown };

std::string SayHelloTo(std::string_view name, UserType type);

}  // namespace hello_service