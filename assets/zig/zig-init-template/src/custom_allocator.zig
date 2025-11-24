// =====================[  SETUP ALLOCATOR  ]=====================
// const ca = @import("custom_allocator.zig").init(.Adaptive);
// const alloc = ca.allocator();
// defer ca.deinit();
// =========================[ END SETUP ]=========================

const std = @import("std");
const mode = @import("builtin").mode;
const is_debug = mode == .Debug or mode == .ReleaseSafe;

const AllocatorKind = enum { Adaptive, Arena };

pub fn init(comptime a_kind: AllocatorKind) type {
    return struct {
        var debug_allocator: std.heap.DebugAllocator(.{}) = .init;
        const base_allocator = if (is_debug) debug_allocator.allocator() else std.heap.smp_allocator;
        var arena = std.heap.ArenaAllocator.init(base_allocator);

        pub fn allocator() std.mem.Allocator {
            return switch (a_kind) {
                .Adaptive => base_allocator,
                .Arena => arena.allocator(),
            };
        }

        pub fn deinit() void {
            if (a_kind == .Arena) arena.deinit();
            _ = if (is_debug) debug_allocator.deinit();
        }
    };
}
