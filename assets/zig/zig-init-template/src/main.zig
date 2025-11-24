const std = @import("std");
const ca = @import("custom_allocator.zig").init(.Adaptive);

pub fn main() void {
    const alloc = ca.allocator();
    defer ca.deinit();

    _ = alloc;
}
