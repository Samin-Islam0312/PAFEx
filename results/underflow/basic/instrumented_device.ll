; ModuleID = '/home/users/sislam3/SBAC-PAD/results/underflow/basic/instrumented_device.bc'
source_filename = "llvm-link"
target datalayout = "e-p6:32:32-i64:64-i128:128-i256:256-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

%struct.float2 = type { float, float }

@fp_invalid_counter = addrspace(1) global i64 0, align 8
@fp_divbyzero_counter = addrspace(1) global i64 0, align 8
@fp_overflow_counter = addrspace(1) global i64 0, align 8
@fp_underflow_counter = addrspace(1) global i64 0, align 8
@fp_total_counter = addrspace(1) global i64 0, align 8
@fp_subnormal_counter = addrspace(1) global i64 0, align 8

; Function Attrs: convergent noinline nounwind optnone
define dso_local noundef zeroext i1 @_Z12is_subnormalf(float noundef %x) #0 !dbg !963 {
entry:
  %__a.addr.i = alloca float, align 4
  %x.addr = alloca float, align 4
  store float %x, ptr %x.addr, align 4
    #dbg_declare(ptr %x.addr, !964, !DIExpression(), !965)
  %0 = load float, ptr %x.addr, align 4, !dbg !966
  %cmp = fcmp contract une float %0, 0.000000e+00, !dbg !967
  br i1 %cmp, label %land.rhs, label %land.end, !dbg !968

land.rhs:                                         ; preds = %entry
  %1 = load float, ptr %x.addr, align 4, !dbg !969
  store float %1, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !970, !DIExpression(), !971)
  %2 = load float, ptr %__a.addr.i, align 4, !dbg !973
  %3 = call float @llvm.nvvm.fabs.f32(float %2), !dbg !974
  %cmp1 = fcmp contract olt float %3, 0x3810000000000000, !dbg !975
  br label %land.end

land.end:                                         ; preds = %land.rhs, %entry
  %4 = phi i1 [ false, %entry ], [ %cmp1, %land.rhs ], !dbg !976
  ret i1 %4, !dbg !977
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fabs.f32(float) #1

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z24testUnderflow_OperationsPfPi(ptr noundef %result, ptr noundef %is_denorm) #2 !dbg !978 {
entry:
  %__a.addr.i68 = alloca float, align 4
  %__a.addr.i66 = alloca float, align 4
  %__b.addr.i = alloca float, align 4
  %__a.addr.i64 = alloca float, align 4
  %__a.addr.i = alloca float, align 4
  %result.addr = alloca ptr, align 8
  %is_denorm.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %tiny = alloca float, align 4
  %a = alloca float, align 4
  %b = alloca float, align 4
  %denorm = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !981, !DIExpression(), !982)
  store ptr %is_denorm, ptr %is_denorm.addr, align 8
    #dbg_declare(ptr %is_denorm.addr, !983, !DIExpression(), !984)
    #dbg_declare(ptr %idx, !985, !DIExpression(), !986)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !987
  store i32 %0, ptr %idx, align 4, !dbg !986
    #dbg_declare(ptr %tiny, !990, !DIExpression(), !991)
  store float 0x3810000000000000, ptr %tiny, align 4, !dbg !991
  %1 = load i32, ptr %idx, align 4, !dbg !992
  %cmp = icmp eq i32 %1, 0, !dbg !994
  br i1 %cmp, label %if.then, label %if.end, !dbg !994

if.then:                                          ; preds = %entry
  %2 = load float, ptr %tiny, align 4, !dbg !995
  %3 = bitcast float %2 to i32, !dbg !997
  %4 = bitcast float %2 to i32, !dbg !997
  %5 = and i32 %4, 2139095040, !dbg !997
  %6 = icmp eq i32 %5, 2139095040, !dbg !997
  %7 = and i32 %4, 8388607, !dbg !997
  %8 = icmp ne i32 %7, 0, !dbg !997
  %is_nan = and i1 %6, %8, !dbg !997
  %9 = and i32 %3, 4194304, !dbg !997
  %10 = icmp eq i32 %9, 0, !dbg !997
  %is_snan = and i1 %is_nan, %10, !dbg !997
  %11 = or i1 %is_snan, false, !dbg !997
  %12 = bitcast float %2 to i32, !dbg !997
  %13 = and i32 %12, 2147483647, !dbg !997
  %is_zero = icmp eq i32 %13, 0, !dbg !997
  %14 = and i1 %is_zero, false, !dbg !997
  %15 = bitcast float %2 to i32, !dbg !997
  %16 = and i32 %15, 2139095040, !dbg !997
  %17 = icmp eq i32 %16, 2139095040, !dbg !997
  %18 = and i32 %15, 8388607, !dbg !997
  %19 = icmp eq i32 %18, 0, !dbg !997
  %is_inf = and i1 %17, %19, !dbg !997
  %20 = and i1 %is_inf, false, !dbg !997
  %21 = or i1 %14, %20, !dbg !997
  %22 = or i1 %11, %21, !dbg !997
  br i1 %22, label %23, label %25, !dbg !997

23:                                               ; preds = %if.then
  %24 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !997
  br label %25, !dbg !997

25:                                               ; preds = %if.then, %23
  %26 = bitcast float %2 to i32, !dbg !997
  %27 = and i32 %26, 2139095040, !dbg !997
  %is_finite = icmp ne i32 %27, 2139095040, !dbg !997
  %28 = bitcast float %2 to i32, !dbg !997
  %29 = and i32 %28, 2147483647, !dbg !997
  %is_zero1 = icmp eq i32 %29, 0, !dbg !997
  %30 = xor i1 %is_zero1, true, !dbg !997
  %31 = and i1 %is_finite, %30, !dbg !997
  %divzero_cond = and i1 false, %31, !dbg !997
  br i1 %divzero_cond, label %32, label %34, !dbg !997

32:                                               ; preds = %25
  %33 = atomicrmw add ptr addrspace(1) @fp_divbyzero_counter, i64 1 monotonic, align 8, !dbg !997
  br label %34, !dbg !997

34:                                               ; preds = %25, %32
  %div = fdiv contract float %2, 1.000000e+02, !dbg !997
  %35 = bitcast float %2 to i32, !dbg !998
  %36 = and i32 %35, 2139095040, !dbg !998
  %is_finite2 = icmp ne i32 %36, 2139095040, !dbg !998
  %37 = and i1 true, %is_finite2, !dbg !998
  %38 = and i1 %37, true, !dbg !998
  %overflow_denom_nonzero = and i1 %38, true, !dbg !998
  %39 = bitcast float %div to i32, !dbg !998
  %40 = and i32 %39, 2139095040, !dbg !998
  %41 = icmp eq i32 %40, 2139095040, !dbg !998
  %42 = and i32 %39, 8388607, !dbg !998
  %43 = icmp eq i32 %42, 0, !dbg !998
  %is_inf3 = and i1 %41, %43, !dbg !998
  %44 = bitcast float %div to i32, !dbg !998
  %45 = and i32 %44, 2147483647, !dbg !998
  %is_maxfinite = icmp eq i32 %45, 2139095039, !dbg !998
  %46 = bitcast float %div to i32, !dbg !998
  %47 = and i32 %46, -2147483648, !dbg !998
  %48 = icmp eq i32 %47, 0, !dbg !998
  %49 = icmp ne i32 %47, 0, !dbg !998
  %is_pos_inf = and i1 %is_inf3, %48, !dbg !998
  %is_neg_inf = and i1 %is_inf3, %49, !dbg !998
  %is_pos_max = and i1 %is_maxfinite, %48, !dbg !998
  %is_neg_max = and i1 %is_maxfinite, %49, !dbg !998
  %overflow_cond = and i1 %overflow_denom_nonzero, %is_inf3, !dbg !998
  br i1 %overflow_cond, label %50, label %52, !dbg !998

50:                                               ; preds = %34
  %51 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !998
  br label %52, !dbg !998

52:                                               ; preds = %34, %50
  %53 = bitcast float %2 to i32, !dbg !998
  %54 = and i32 %53, 2139095040, !dbg !998
  %55 = icmp eq i32 %54, 0, !dbg !998
  %56 = and i32 %53, 8388607, !dbg !998
  %57 = icmp ne i32 %56, 0, !dbg !998
  %is_subnormal = and i1 %55, %57, !dbg !998
  %58 = xor i1 %is_subnormal, true, !dbg !998
  %59 = and i1 true, %58, !dbg !998
  %60 = and i1 %59, true, !dbg !998
  %61 = bitcast float %div to i32, !dbg !998
  %62 = and i32 %61, 2139095040, !dbg !998
  %63 = icmp eq i32 %62, 0, !dbg !998
  %64 = and i32 %61, 8388607, !dbg !998
  %65 = icmp ne i32 %64, 0, !dbg !998
  %is_subnormal4 = and i1 %63, %65, !dbg !998
  %66 = bitcast float %div to i32, !dbg !998
  %67 = and i32 %66, 2147483647, !dbg !998
  %is_zero5 = icmp eq i32 %67, 0, !dbg !998
  %68 = bitcast float %2 to i32, !dbg !998
  %69 = and i32 %68, 2147483647, !dbg !998
  %is_zero6 = icmp eq i32 %69, 0, !dbg !998
  %70 = xor i1 %is_zero6, true, !dbg !998
  %71 = and i1 %70, true, !dbg !998
  %72 = and i1 %is_zero5, %71, !dbg !998
  %is_tiny = or i1 %is_subnormal4, %72, !dbg !998
  %underflow_cond = and i1 %60, %is_tiny, !dbg !998
  br i1 %underflow_cond, label %73, label %75, !dbg !998

73:                                               ; preds = %52
  %74 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !998
  br label %75, !dbg !998

75:                                               ; preds = %52, %73
  %76 = load ptr, ptr %result.addr, align 8, !dbg !998
  %arrayidx = getelementptr inbounds float, ptr %76, i64 0, !dbg !998
  store float %div, ptr %arrayidx, align 4, !dbg !999
  %77 = load ptr, ptr %result.addr, align 8, !dbg !1000
  %arrayidx1 = getelementptr inbounds float, ptr %77, i64 0, !dbg !1000
  %78 = load float, ptr %arrayidx1, align 4, !dbg !1000
  %call2 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %78) #4, !dbg !1001
  %79 = zext i1 %call2 to i64, !dbg !1001
  %cond = select i1 %call2, i32 1, i32 0, !dbg !1001
  %80 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1002
  %arrayidx3 = getelementptr inbounds i32, ptr %80, i64 0, !dbg !1002
  store i32 %cond, ptr %arrayidx3, align 4, !dbg !1003
  br label %if.end, !dbg !1004

if.end:                                           ; preds = %75, %entry
  %81 = load i32, ptr %idx, align 4, !dbg !1005
  %cmp4 = icmp eq i32 %81, 1, !dbg !1007
  br i1 %cmp4, label %if.then5, label %if.end11, !dbg !1007

if.then5:                                         ; preds = %if.end
  %82 = load float, ptr %tiny, align 4, !dbg !1008
  %83 = bitcast float %82 to i32, !dbg !1010
  %84 = bitcast float %82 to i32, !dbg !1010
  %85 = and i32 %84, 2139095040, !dbg !1010
  %86 = icmp eq i32 %85, 2139095040, !dbg !1010
  %87 = and i32 %84, 8388607, !dbg !1010
  %88 = icmp ne i32 %87, 0, !dbg !1010
  %is_nan7 = and i1 %86, %88, !dbg !1010
  %89 = and i32 %83, 4194304, !dbg !1010
  %90 = icmp eq i32 %89, 0, !dbg !1010
  %is_snan8 = and i1 %is_nan7, %90, !dbg !1010
  %91 = or i1 %is_snan8, false, !dbg !1010
  %92 = bitcast float %82 to i32, !dbg !1010
  %93 = and i32 %92, 2147483647, !dbg !1010
  %is_zero9 = icmp eq i32 %93, 0, !dbg !1010
  %94 = and i1 %is_zero9, false, !dbg !1010
  %95 = bitcast float %82 to i32, !dbg !1010
  %96 = and i32 %95, 2139095040, !dbg !1010
  %97 = icmp eq i32 %96, 2139095040, !dbg !1010
  %98 = and i32 %95, 8388607, !dbg !1010
  %99 = icmp eq i32 %98, 0, !dbg !1010
  %is_inf10 = and i1 %97, %99, !dbg !1010
  %100 = and i1 %is_inf10, false, !dbg !1010
  %101 = or i1 %94, %100, !dbg !1010
  %102 = or i1 %91, %101, !dbg !1010
  br i1 %102, label %103, label %105, !dbg !1010

103:                                              ; preds = %if.then5
  %104 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1010
  br label %105, !dbg !1010

105:                                              ; preds = %if.then5, %103
  %mul = fmul contract float %82, 0x3F847AE140000000, !dbg !1010
  %106 = bitcast float %82 to i32, !dbg !1011
  %107 = and i32 %106, 2139095040, !dbg !1011
  %is_finite11 = icmp ne i32 %107, 2139095040, !dbg !1011
  %108 = and i1 true, %is_finite11, !dbg !1011
  %109 = and i1 %108, true, !dbg !1011
  %110 = bitcast float %mul to i32, !dbg !1011
  %111 = and i32 %110, 2139095040, !dbg !1011
  %112 = icmp eq i32 %111, 2139095040, !dbg !1011
  %113 = and i32 %110, 8388607, !dbg !1011
  %114 = icmp eq i32 %113, 0, !dbg !1011
  %is_inf12 = and i1 %112, %114, !dbg !1011
  %115 = bitcast float %mul to i32, !dbg !1011
  %116 = and i32 %115, 2147483647, !dbg !1011
  %is_maxfinite13 = icmp eq i32 %116, 2139095039, !dbg !1011
  %117 = bitcast float %mul to i32, !dbg !1011
  %118 = and i32 %117, -2147483648, !dbg !1011
  %119 = icmp eq i32 %118, 0, !dbg !1011
  %120 = icmp ne i32 %118, 0, !dbg !1011
  %is_pos_inf14 = and i1 %is_inf12, %119, !dbg !1011
  %is_neg_inf15 = and i1 %is_inf12, %120, !dbg !1011
  %is_pos_max16 = and i1 %is_maxfinite13, %119, !dbg !1011
  %is_neg_max17 = and i1 %is_maxfinite13, %120, !dbg !1011
  %overflow_cond18 = and i1 %109, %is_inf12, !dbg !1011
  br i1 %overflow_cond18, label %121, label %123, !dbg !1011

121:                                              ; preds = %105
  %122 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1011
  br label %123, !dbg !1011

123:                                              ; preds = %105, %121
  %124 = bitcast float %82 to i32, !dbg !1011
  %125 = and i32 %124, 2139095040, !dbg !1011
  %126 = icmp eq i32 %125, 0, !dbg !1011
  %127 = and i32 %124, 8388607, !dbg !1011
  %128 = icmp ne i32 %127, 0, !dbg !1011
  %is_subnormal19 = and i1 %126, %128, !dbg !1011
  %129 = xor i1 %is_subnormal19, true, !dbg !1011
  %130 = and i1 true, %129, !dbg !1011
  %131 = and i1 %130, true, !dbg !1011
  %132 = bitcast float %mul to i32, !dbg !1011
  %133 = and i32 %132, 2139095040, !dbg !1011
  %134 = icmp eq i32 %133, 0, !dbg !1011
  %135 = and i32 %132, 8388607, !dbg !1011
  %136 = icmp ne i32 %135, 0, !dbg !1011
  %is_subnormal20 = and i1 %134, %136, !dbg !1011
  %137 = bitcast float %mul to i32, !dbg !1011
  %138 = and i32 %137, 2147483647, !dbg !1011
  %is_zero21 = icmp eq i32 %138, 0, !dbg !1011
  %139 = bitcast float %82 to i32, !dbg !1011
  %140 = and i32 %139, 2147483647, !dbg !1011
  %is_zero22 = icmp eq i32 %140, 0, !dbg !1011
  %141 = xor i1 %is_zero22, true, !dbg !1011
  %142 = and i1 %141, true, !dbg !1011
  %143 = and i1 %is_zero21, %142, !dbg !1011
  %is_tiny23 = or i1 %is_subnormal20, %143, !dbg !1011
  %underflow_cond24 = and i1 %131, %is_tiny23, !dbg !1011
  br i1 %underflow_cond24, label %144, label %146, !dbg !1011

144:                                              ; preds = %123
  %145 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1011
  br label %146, !dbg !1011

146:                                              ; preds = %123, %144
  %147 = load ptr, ptr %result.addr, align 8, !dbg !1011
  %arrayidx6 = getelementptr inbounds float, ptr %147, i64 1, !dbg !1011
  store float %mul, ptr %arrayidx6, align 4, !dbg !1012
  %148 = load ptr, ptr %result.addr, align 8, !dbg !1013
  %arrayidx7 = getelementptr inbounds float, ptr %148, i64 1, !dbg !1013
  %149 = load float, ptr %arrayidx7, align 4, !dbg !1013
  %call8 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %149) #4, !dbg !1014
  %150 = zext i1 %call8 to i64, !dbg !1014
  %cond9 = select i1 %call8, i32 1, i32 0, !dbg !1014
  %151 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1015
  %arrayidx10 = getelementptr inbounds i32, ptr %151, i64 1, !dbg !1015
  store i32 %cond9, ptr %arrayidx10, align 4, !dbg !1016
  br label %if.end11, !dbg !1017

if.end11:                                         ; preds = %146, %if.end
  %152 = load i32, ptr %idx, align 4, !dbg !1018
  %cmp12 = icmp eq i32 %152, 2, !dbg !1020
  br i1 %cmp12, label %if.then13, label %if.end19, !dbg !1020

if.then13:                                        ; preds = %if.end11
    #dbg_declare(ptr %a, !1021, !DIExpression(), !1023)
  store float 0x38119999A0000000, ptr %a, align 4, !dbg !1023
    #dbg_declare(ptr %b, !1024, !DIExpression(), !1025)
  store float 0x3810000000000000, ptr %b, align 4, !dbg !1025
  %153 = load float, ptr %a, align 4, !dbg !1026
  %154 = load float, ptr %b, align 4, !dbg !1027
  %155 = bitcast float %153 to i32, !dbg !1028
  %156 = bitcast float %153 to i32, !dbg !1028
  %157 = and i32 %156, 2139095040, !dbg !1028
  %158 = icmp eq i32 %157, 2139095040, !dbg !1028
  %159 = and i32 %156, 8388607, !dbg !1028
  %160 = icmp ne i32 %159, 0, !dbg !1028
  %is_nan25 = and i1 %158, %160, !dbg !1028
  %161 = and i32 %155, 4194304, !dbg !1028
  %162 = icmp eq i32 %161, 0, !dbg !1028
  %is_snan26 = and i1 %is_nan25, %162, !dbg !1028
  %163 = bitcast float %154 to i32, !dbg !1028
  %164 = bitcast float %154 to i32, !dbg !1028
  %165 = and i32 %164, 2139095040, !dbg !1028
  %166 = icmp eq i32 %165, 2139095040, !dbg !1028
  %167 = and i32 %164, 8388607, !dbg !1028
  %168 = icmp ne i32 %167, 0, !dbg !1028
  %is_nan27 = and i1 %166, %168, !dbg !1028
  %169 = and i32 %163, 4194304, !dbg !1028
  %170 = icmp eq i32 %169, 0, !dbg !1028
  %is_snan28 = and i1 %is_nan27, %170, !dbg !1028
  %171 = or i1 %is_snan26, %is_snan28, !dbg !1028
  %172 = bitcast float %153 to i32, !dbg !1028
  %173 = and i32 %172, 2139095040, !dbg !1028
  %174 = icmp eq i32 %173, 2139095040, !dbg !1028
  %175 = and i32 %172, 8388607, !dbg !1028
  %176 = icmp eq i32 %175, 0, !dbg !1028
  %is_inf29 = and i1 %174, %176, !dbg !1028
  %177 = bitcast float %154 to i32, !dbg !1028
  %178 = and i32 %177, 2139095040, !dbg !1028
  %179 = icmp eq i32 %178, 2139095040, !dbg !1028
  %180 = and i32 %177, 8388607, !dbg !1028
  %181 = icmp eq i32 %180, 0, !dbg !1028
  %is_inf30 = and i1 %179, %181, !dbg !1028
  %182 = and i1 %is_inf29, %is_inf30, !dbg !1028
  %183 = bitcast float %153 to i32, !dbg !1028
  %184 = bitcast float %154 to i32, !dbg !1028
  %185 = and i32 %183, -2147483648, !dbg !1028
  %186 = and i32 %184, -2147483648, !dbg !1028
  %187 = icmp eq i32 %185, %186, !dbg !1028
  %188 = and i1 %182, %187, !dbg !1028
  %189 = or i1 %171, %188, !dbg !1028
  br i1 %189, label %190, label %192, !dbg !1028

190:                                              ; preds = %if.then13
  %191 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1028
  br label %192, !dbg !1028

192:                                              ; preds = %if.then13, %190
  %sub = fsub contract float %153, %154, !dbg !1028
  %193 = bitcast float %153 to i32, !dbg !1029
  %194 = and i32 %193, 2139095040, !dbg !1029
  %is_finite31 = icmp ne i32 %194, 2139095040, !dbg !1029
  %195 = and i1 true, %is_finite31, !dbg !1029
  %196 = bitcast float %154 to i32, !dbg !1029
  %197 = and i32 %196, 2139095040, !dbg !1029
  %is_finite32 = icmp ne i32 %197, 2139095040, !dbg !1029
  %198 = and i1 %195, %is_finite32, !dbg !1029
  %199 = bitcast float %sub to i32, !dbg !1029
  %200 = and i32 %199, 2139095040, !dbg !1029
  %201 = icmp eq i32 %200, 2139095040, !dbg !1029
  %202 = and i32 %199, 8388607, !dbg !1029
  %203 = icmp eq i32 %202, 0, !dbg !1029
  %is_inf33 = and i1 %201, %203, !dbg !1029
  %204 = bitcast float %sub to i32, !dbg !1029
  %205 = and i32 %204, 2147483647, !dbg !1029
  %is_maxfinite34 = icmp eq i32 %205, 2139095039, !dbg !1029
  %206 = bitcast float %sub to i32, !dbg !1029
  %207 = and i32 %206, -2147483648, !dbg !1029
  %208 = icmp eq i32 %207, 0, !dbg !1029
  %209 = icmp ne i32 %207, 0, !dbg !1029
  %is_pos_inf35 = and i1 %is_inf33, %208, !dbg !1029
  %is_neg_inf36 = and i1 %is_inf33, %209, !dbg !1029
  %is_pos_max37 = and i1 %is_maxfinite34, %208, !dbg !1029
  %is_neg_max38 = and i1 %is_maxfinite34, %209, !dbg !1029
  %overflow_cond39 = and i1 %198, %is_inf33, !dbg !1029
  br i1 %overflow_cond39, label %210, label %212, !dbg !1029

210:                                              ; preds = %192
  %211 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1029
  br label %212, !dbg !1029

212:                                              ; preds = %192, %210
  %213 = load ptr, ptr %result.addr, align 8, !dbg !1029
  %arrayidx14 = getelementptr inbounds float, ptr %213, i64 2, !dbg !1029
  store float %sub, ptr %arrayidx14, align 4, !dbg !1030
  %214 = load ptr, ptr %result.addr, align 8, !dbg !1031
  %arrayidx15 = getelementptr inbounds float, ptr %214, i64 2, !dbg !1031
  %215 = load float, ptr %arrayidx15, align 4, !dbg !1031
  %call16 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %215) #4, !dbg !1032
  %216 = zext i1 %call16 to i64, !dbg !1032
  %cond17 = select i1 %call16, i32 1, i32 0, !dbg !1032
  %217 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1033
  %arrayidx18 = getelementptr inbounds i32, ptr %217, i64 2, !dbg !1033
  store i32 %cond17, ptr %arrayidx18, align 4, !dbg !1034
  br label %if.end19, !dbg !1035

if.end19:                                         ; preds = %212, %if.end11
  %218 = load i32, ptr %idx, align 4, !dbg !1036
  %cmp20 = icmp eq i32 %218, 3, !dbg !1038
  br i1 %cmp20, label %if.then21, label %if.end27, !dbg !1038

if.then21:                                        ; preds = %if.end19
    #dbg_declare(ptr %denorm, !1039, !DIExpression(), !1041)
  store float 0x37D9999A00000000, ptr %denorm, align 4, !dbg !1041
  %219 = load float, ptr %denorm, align 4, !dbg !1042
  %220 = load float, ptr %denorm, align 4, !dbg !1043
  %221 = bitcast float %219 to i32, !dbg !1044
  %222 = bitcast float %219 to i32, !dbg !1044
  %223 = and i32 %222, 2139095040, !dbg !1044
  %224 = icmp eq i32 %223, 2139095040, !dbg !1044
  %225 = and i32 %222, 8388607, !dbg !1044
  %226 = icmp ne i32 %225, 0, !dbg !1044
  %is_nan40 = and i1 %224, %226, !dbg !1044
  %227 = and i32 %221, 4194304, !dbg !1044
  %228 = icmp eq i32 %227, 0, !dbg !1044
  %is_snan41 = and i1 %is_nan40, %228, !dbg !1044
  %229 = bitcast float %220 to i32, !dbg !1044
  %230 = bitcast float %220 to i32, !dbg !1044
  %231 = and i32 %230, 2139095040, !dbg !1044
  %232 = icmp eq i32 %231, 2139095040, !dbg !1044
  %233 = and i32 %230, 8388607, !dbg !1044
  %234 = icmp ne i32 %233, 0, !dbg !1044
  %is_nan42 = and i1 %232, %234, !dbg !1044
  %235 = and i32 %229, 4194304, !dbg !1044
  %236 = icmp eq i32 %235, 0, !dbg !1044
  %is_snan43 = and i1 %is_nan42, %236, !dbg !1044
  %237 = or i1 %is_snan41, %is_snan43, !dbg !1044
  %238 = bitcast float %219 to i32, !dbg !1044
  %239 = and i32 %238, 2139095040, !dbg !1044
  %240 = icmp eq i32 %239, 2139095040, !dbg !1044
  %241 = and i32 %238, 8388607, !dbg !1044
  %242 = icmp eq i32 %241, 0, !dbg !1044
  %is_inf44 = and i1 %240, %242, !dbg !1044
  %243 = bitcast float %220 to i32, !dbg !1044
  %244 = and i32 %243, 2139095040, !dbg !1044
  %245 = icmp eq i32 %244, 2139095040, !dbg !1044
  %246 = and i32 %243, 8388607, !dbg !1044
  %247 = icmp eq i32 %246, 0, !dbg !1044
  %is_inf45 = and i1 %245, %247, !dbg !1044
  %248 = and i1 %is_inf44, %is_inf45, !dbg !1044
  %249 = bitcast float %219 to i32, !dbg !1044
  %250 = bitcast float %220 to i32, !dbg !1044
  %251 = and i32 %249, -2147483648, !dbg !1044
  %252 = and i32 %250, -2147483648, !dbg !1044
  %253 = icmp ne i32 %251, %252, !dbg !1044
  %254 = and i1 %248, %253, !dbg !1044
  %255 = or i1 %237, %254, !dbg !1044
  br i1 %255, label %256, label %258, !dbg !1044

256:                                              ; preds = %if.then21
  %257 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1044
  br label %258, !dbg !1044

258:                                              ; preds = %if.then21, %256
  %add = fadd contract float %219, %220, !dbg !1044
  %259 = bitcast float %219 to i32, !dbg !1045
  %260 = and i32 %259, 2139095040, !dbg !1045
  %is_finite46 = icmp ne i32 %260, 2139095040, !dbg !1045
  %261 = and i1 true, %is_finite46, !dbg !1045
  %262 = bitcast float %220 to i32, !dbg !1045
  %263 = and i32 %262, 2139095040, !dbg !1045
  %is_finite47 = icmp ne i32 %263, 2139095040, !dbg !1045
  %264 = and i1 %261, %is_finite47, !dbg !1045
  %265 = bitcast float %add to i32, !dbg !1045
  %266 = and i32 %265, 2139095040, !dbg !1045
  %267 = icmp eq i32 %266, 2139095040, !dbg !1045
  %268 = and i32 %265, 8388607, !dbg !1045
  %269 = icmp eq i32 %268, 0, !dbg !1045
  %is_inf48 = and i1 %267, %269, !dbg !1045
  %270 = bitcast float %add to i32, !dbg !1045
  %271 = and i32 %270, 2147483647, !dbg !1045
  %is_maxfinite49 = icmp eq i32 %271, 2139095039, !dbg !1045
  %272 = bitcast float %add to i32, !dbg !1045
  %273 = and i32 %272, -2147483648, !dbg !1045
  %274 = icmp eq i32 %273, 0, !dbg !1045
  %275 = icmp ne i32 %273, 0, !dbg !1045
  %is_pos_inf50 = and i1 %is_inf48, %274, !dbg !1045
  %is_neg_inf51 = and i1 %is_inf48, %275, !dbg !1045
  %is_pos_max52 = and i1 %is_maxfinite49, %274, !dbg !1045
  %is_neg_max53 = and i1 %is_maxfinite49, %275, !dbg !1045
  %overflow_cond54 = and i1 %264, %is_inf48, !dbg !1045
  br i1 %overflow_cond54, label %276, label %278, !dbg !1045

276:                                              ; preds = %258
  %277 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1045
  br label %278, !dbg !1045

278:                                              ; preds = %258, %276
  %279 = load ptr, ptr %result.addr, align 8, !dbg !1045
  %arrayidx22 = getelementptr inbounds float, ptr %279, i64 3, !dbg !1045
  store float %add, ptr %arrayidx22, align 4, !dbg !1046
  %280 = load ptr, ptr %result.addr, align 8, !dbg !1047
  %arrayidx23 = getelementptr inbounds float, ptr %280, i64 3, !dbg !1047
  %281 = load float, ptr %arrayidx23, align 4, !dbg !1047
  %call24 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %281) #4, !dbg !1048
  %282 = zext i1 %call24 to i64, !dbg !1048
  %cond25 = select i1 %call24, i32 1, i32 0, !dbg !1048
  %283 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1049
  %arrayidx26 = getelementptr inbounds i32, ptr %283, i64 3, !dbg !1049
  store i32 %cond25, ptr %arrayidx26, align 4, !dbg !1050
  br label %if.end27, !dbg !1051

if.end27:                                         ; preds = %278, %if.end19
  %284 = load i32, ptr %idx, align 4, !dbg !1052
  %cmp28 = icmp eq i32 %284, 4, !dbg !1054
  br i1 %cmp28, label %if.then29, label %if.end36, !dbg !1054

if.then29:                                        ; preds = %if.end27
  %285 = load float, ptr %tiny, align 4, !dbg !1055
  store float %285, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !1057, !DIExpression(), !1058)
  %286 = load float, ptr %__a.addr.i, align 4, !dbg !1060
  %287 = bitcast float %286 to i32, !dbg !1061
  %288 = bitcast float %286 to i32, !dbg !1061
  %289 = and i32 %288, 2139095040, !dbg !1061
  %290 = icmp eq i32 %289, 2139095040, !dbg !1061
  %291 = and i32 %288, 8388607, !dbg !1061
  %292 = icmp ne i32 %291, 0, !dbg !1061
  %is_nan55 = and i1 %290, %292, !dbg !1061
  %293 = and i32 %287, 4194304, !dbg !1061
  %294 = icmp eq i32 %293, 0, !dbg !1061
  %is_snan56 = and i1 %is_nan55, %294, !dbg !1061
  %295 = bitcast float %286 to i32, !dbg !1061
  %296 = and i32 %295, -2147483648, !dbg !1061
  %is_neg = icmp ne i32 %296, 0, !dbg !1061
  %297 = or i1 %is_snan56, %is_neg, !dbg !1061
  br i1 %297, label %298, label %300, !dbg !1061

298:                                              ; preds = %if.then29
  %299 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1061
  br label %300, !dbg !1061

300:                                              ; preds = %if.then29, %298
  %301 = call float @llvm.nvvm.sqrt.approx.f(float %286) #5, !dbg !1061
  %302 = load ptr, ptr %result.addr, align 8, !dbg !1062
  %arrayidx31 = getelementptr inbounds float, ptr %302, i64 4, !dbg !1062
  store float %301, ptr %arrayidx31, align 4, !dbg !1063
  %303 = load ptr, ptr %result.addr, align 8, !dbg !1064
  %arrayidx32 = getelementptr inbounds float, ptr %303, i64 4, !dbg !1064
  %304 = load float, ptr %arrayidx32, align 4, !dbg !1064
  %call33 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %304) #4, !dbg !1065
  %305 = zext i1 %call33 to i64, !dbg !1065
  %cond34 = select i1 %call33, i32 1, i32 0, !dbg !1065
  %306 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1066
  %arrayidx35 = getelementptr inbounds i32, ptr %306, i64 4, !dbg !1066
  store i32 %cond34, ptr %arrayidx35, align 4, !dbg !1067
  br label %if.end36, !dbg !1068

if.end36:                                         ; preds = %300, %if.end27
  %307 = load i32, ptr %idx, align 4, !dbg !1069
  %cmp37 = icmp eq i32 %307, 5, !dbg !1071
  br i1 %cmp37, label %if.then38, label %if.end45, !dbg !1071

if.then38:                                        ; preds = %if.end36
  store float -1.000000e+02, ptr %__a.addr.i64, align 4
    #dbg_declare(ptr %__a.addr.i64, !1072, !DIExpression(), !1073)
  %308 = load float, ptr %__a.addr.i64, align 4, !dbg !1076
  %309 = bitcast float %308 to i32, !dbg !1077
  %310 = bitcast float %308 to i32, !dbg !1077
  %311 = and i32 %310, 2139095040, !dbg !1077
  %312 = icmp eq i32 %311, 2139095040, !dbg !1077
  %313 = and i32 %310, 8388607, !dbg !1077
  %314 = icmp ne i32 %313, 0, !dbg !1077
  %is_nan57 = and i1 %312, %314, !dbg !1077
  %315 = and i32 %309, 4194304, !dbg !1077
  %316 = icmp eq i32 %315, 0, !dbg !1077
  %is_snan58 = and i1 %is_nan57, %316, !dbg !1077
  %317 = or i1 %is_snan58, false, !dbg !1077
  %318 = or i1 %317, false, !dbg !1077
  %319 = bitcast float %308 to i32, !dbg !1077
  %320 = and i32 %319, 2147483647, !dbg !1077
  %is_zero59 = icmp eq i32 %320, 0, !dbg !1077
  %321 = and i1 %is_zero59, false, !dbg !1077
  %322 = bitcast float %308 to i32, !dbg !1077
  %323 = and i32 %322, 2139095040, !dbg !1077
  %324 = icmp eq i32 %323, 2139095040, !dbg !1077
  %325 = and i32 %322, 8388607, !dbg !1077
  %326 = icmp eq i32 %325, 0, !dbg !1077
  %is_inf60 = and i1 %324, %326, !dbg !1077
  %327 = and i1 %is_inf60, false, !dbg !1077
  %328 = or i1 %321, %327, !dbg !1077
  %329 = or i1 %318, %328, !dbg !1077
  br i1 %329, label %330, label %332, !dbg !1077

330:                                              ; preds = %if.then38
  %331 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %332, !dbg !1077

332:                                              ; preds = %if.then38, %330
  %333 = call float @llvm.nvvm.fma.rn.f(float %308, float 0x3F777313A0000000, float 5.000000e-01) #5, !dbg !1077
  %334 = bitcast float %308 to i32, !dbg !1077
  %335 = and i32 %334, 2139095040, !dbg !1077
  %is_finite61 = icmp ne i32 %335, 2139095040, !dbg !1077
  %336 = and i1 true, %is_finite61, !dbg !1077
  %337 = and i1 %336, true, !dbg !1077
  %338 = bitcast float %333 to i32, !dbg !1077
  %339 = and i32 %338, 2139095040, !dbg !1077
  %340 = icmp eq i32 %339, 2139095040, !dbg !1077
  %341 = and i32 %338, 8388607, !dbg !1077
  %342 = icmp eq i32 %341, 0, !dbg !1077
  %is_inf62 = and i1 %340, %342, !dbg !1077
  %343 = bitcast float %333 to i32, !dbg !1077
  %344 = and i32 %343, 2147483647, !dbg !1077
  %is_maxfinite63 = icmp eq i32 %344, 2139095039, !dbg !1077
  %345 = bitcast float %333 to i32, !dbg !1077
  %346 = and i32 %345, -2147483648, !dbg !1077
  %347 = icmp eq i32 %346, 0, !dbg !1077
  %348 = icmp ne i32 %346, 0, !dbg !1077
  %is_pos_inf64 = and i1 %is_inf62, %347, !dbg !1077
  %is_neg_inf65 = and i1 %is_inf62, %348, !dbg !1077
  %is_pos_max66 = and i1 %is_maxfinite63, %347, !dbg !1077
  %is_neg_max67 = and i1 %is_maxfinite63, %348, !dbg !1077
  %overflow_cond68 = and i1 %337, %is_inf62, !dbg !1077
  br i1 %overflow_cond68, label %349, label %351, !dbg !1077

349:                                              ; preds = %332
  %350 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %351, !dbg !1077

351:                                              ; preds = %332, %349
  %352 = bitcast float %308 to i32, !dbg !1077
  %353 = and i32 %352, 2139095040, !dbg !1077
  %354 = icmp eq i32 %353, 0, !dbg !1077
  %355 = and i32 %352, 8388607, !dbg !1077
  %356 = icmp ne i32 %355, 0, !dbg !1077
  %is_subnormal69 = and i1 %354, %356, !dbg !1077
  %357 = xor i1 %is_subnormal69, true, !dbg !1077
  %358 = and i1 true, %357, !dbg !1077
  %359 = and i1 %358, true, !dbg !1077
  %360 = and i1 %359, true, !dbg !1077
  %361 = bitcast float %333 to i32, !dbg !1077
  %362 = and i32 %361, 2139095040, !dbg !1077
  %363 = icmp eq i32 %362, 0, !dbg !1077
  %364 = and i32 %361, 8388607, !dbg !1077
  %365 = icmp ne i32 %364, 0, !dbg !1077
  %is_subnormal70 = and i1 %363, %365, !dbg !1077
  %is_tiny71 = or i1 %is_subnormal70, false, !dbg !1077
  %underflow_cond72 = and i1 %360, %is_tiny71, !dbg !1077
  br i1 %underflow_cond72, label %366, label %368, !dbg !1077

366:                                              ; preds = %351
  %367 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %368, !dbg !1077

368:                                              ; preds = %351, %366
  %369 = call float @llvm.nvvm.saturate.f(float %333) #5, !dbg !1077
  %370 = bitcast float %369 to i32, !dbg !1077
  %371 = bitcast float %369 to i32, !dbg !1077
  %372 = and i32 %371, 2139095040, !dbg !1077
  %373 = icmp eq i32 %372, 2139095040, !dbg !1077
  %374 = and i32 %371, 8388607, !dbg !1077
  %375 = icmp ne i32 %374, 0, !dbg !1077
  %is_nan73 = and i1 %373, %375, !dbg !1077
  %376 = and i32 %370, 4194304, !dbg !1077
  %377 = icmp eq i32 %376, 0, !dbg !1077
  %is_snan74 = and i1 %is_nan73, %377, !dbg !1077
  %378 = or i1 %is_snan74, false, !dbg !1077
  %379 = or i1 %378, false, !dbg !1077
  %380 = bitcast float %369 to i32, !dbg !1077
  %381 = and i32 %380, 2147483647, !dbg !1077
  %is_zero75 = icmp eq i32 %381, 0, !dbg !1077
  %382 = and i1 %is_zero75, false, !dbg !1077
  %383 = bitcast float %369 to i32, !dbg !1077
  %384 = and i32 %383, 2139095040, !dbg !1077
  %385 = icmp eq i32 %384, 2139095040, !dbg !1077
  %386 = and i32 %383, 8388607, !dbg !1077
  %387 = icmp eq i32 %386, 0, !dbg !1077
  %is_inf76 = and i1 %385, %387, !dbg !1077
  %388 = and i1 %is_inf76, false, !dbg !1077
  %389 = or i1 %382, %388, !dbg !1077
  %390 = or i1 %379, %389, !dbg !1077
  br i1 %390, label %391, label %393, !dbg !1077

391:                                              ; preds = %368
  %392 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %393, !dbg !1077

393:                                              ; preds = %368, %391
  %394 = call float @llvm.nvvm.fma.rm.f(float %369, float 2.520000e+02, float 0x4168000020000000) #5, !dbg !1077
  %395 = bitcast float %369 to i32, !dbg !1077
  %396 = and i32 %395, 2139095040, !dbg !1077
  %is_finite77 = icmp ne i32 %396, 2139095040, !dbg !1077
  %397 = and i1 true, %is_finite77, !dbg !1077
  %398 = and i1 %397, true, !dbg !1077
  %399 = bitcast float %394 to i32, !dbg !1077
  %400 = and i32 %399, 2139095040, !dbg !1077
  %401 = icmp eq i32 %400, 2139095040, !dbg !1077
  %402 = and i32 %399, 8388607, !dbg !1077
  %403 = icmp eq i32 %402, 0, !dbg !1077
  %is_inf78 = and i1 %401, %403, !dbg !1077
  %404 = bitcast float %394 to i32, !dbg !1077
  %405 = and i32 %404, 2147483647, !dbg !1077
  %is_maxfinite79 = icmp eq i32 %405, 2139095039, !dbg !1077
  %406 = bitcast float %394 to i32, !dbg !1077
  %407 = and i32 %406, -2147483648, !dbg !1077
  %408 = icmp eq i32 %407, 0, !dbg !1077
  %409 = icmp ne i32 %407, 0, !dbg !1077
  %is_pos_inf80 = and i1 %is_inf78, %408, !dbg !1077
  %is_neg_inf81 = and i1 %is_inf78, %409, !dbg !1077
  %is_pos_max82 = and i1 %is_maxfinite79, %408, !dbg !1077
  %is_neg_max83 = and i1 %is_maxfinite79, %409, !dbg !1077
  %overflow_rm = or i1 %is_neg_inf81, %is_pos_max82, !dbg !1077
  %overflow_cond84 = and i1 %398, %overflow_rm, !dbg !1077
  br i1 %overflow_cond84, label %410, label %412, !dbg !1077

410:                                              ; preds = %393
  %411 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %412, !dbg !1077

412:                                              ; preds = %393, %410
  %413 = bitcast float %369 to i32, !dbg !1077
  %414 = and i32 %413, 2139095040, !dbg !1077
  %415 = icmp eq i32 %414, 0, !dbg !1077
  %416 = and i32 %413, 8388607, !dbg !1077
  %417 = icmp ne i32 %416, 0, !dbg !1077
  %is_subnormal85 = and i1 %415, %417, !dbg !1077
  %418 = xor i1 %is_subnormal85, true, !dbg !1077
  %419 = and i1 true, %418, !dbg !1077
  %420 = and i1 %419, true, !dbg !1077
  %421 = and i1 %420, true, !dbg !1077
  %422 = bitcast float %394 to i32, !dbg !1077
  %423 = and i32 %422, 2139095040, !dbg !1077
  %424 = icmp eq i32 %423, 0, !dbg !1077
  %425 = and i32 %422, 8388607, !dbg !1077
  %426 = icmp ne i32 %425, 0, !dbg !1077
  %is_subnormal86 = and i1 %424, %426, !dbg !1077
  %is_tiny87 = or i1 %is_subnormal86, false, !dbg !1077
  %underflow_cond88 = and i1 %421, %is_tiny87, !dbg !1077
  br i1 %underflow_cond88, label %427, label %429, !dbg !1077

427:                                              ; preds = %412
  %428 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %429, !dbg !1077

429:                                              ; preds = %412, %427
  %430 = bitcast float %394 to i32, !dbg !1077
  %431 = bitcast float %394 to i32, !dbg !1077
  %432 = and i32 %431, 2139095040, !dbg !1077
  %433 = icmp eq i32 %432, 2139095040, !dbg !1077
  %434 = and i32 %431, 8388607, !dbg !1077
  %435 = icmp ne i32 %434, 0, !dbg !1077
  %is_nan89 = and i1 %433, %435, !dbg !1077
  %436 = and i32 %430, 4194304, !dbg !1077
  %437 = icmp eq i32 %436, 0, !dbg !1077
  %is_snan90 = and i1 %is_nan89, %437, !dbg !1077
  %438 = or i1 %is_snan90, false, !dbg !1077
  %439 = bitcast float %394 to i32, !dbg !1077
  %440 = and i32 %439, 2139095040, !dbg !1077
  %441 = icmp eq i32 %440, 2139095040, !dbg !1077
  %442 = and i32 %439, 8388607, !dbg !1077
  %443 = icmp eq i32 %442, 0, !dbg !1077
  %is_inf91 = and i1 %441, %443, !dbg !1077
  %444 = and i1 %is_inf91, false, !dbg !1077
  %445 = bitcast float %394 to i32, !dbg !1077
  %446 = and i32 %445, -2147483648, !dbg !1077
  %447 = icmp eq i32 %446, 0, !dbg !1077
  %448 = and i1 %444, %447, !dbg !1077
  %449 = or i1 %438, %448, !dbg !1077
  br i1 %449, label %450, label %452, !dbg !1077

450:                                              ; preds = %429
  %451 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %452, !dbg !1077

452:                                              ; preds = %429, %450
  %453 = fsub float %394, 0x4168000FE0000000, !dbg !1077
  %454 = bitcast float %394 to i32, !dbg !1077
  %455 = and i32 %454, 2139095040, !dbg !1077
  %is_finite92 = icmp ne i32 %455, 2139095040, !dbg !1077
  %456 = and i1 true, %is_finite92, !dbg !1077
  %457 = and i1 %456, true, !dbg !1077
  %458 = bitcast float %453 to i32, !dbg !1077
  %459 = and i32 %458, 2139095040, !dbg !1077
  %460 = icmp eq i32 %459, 2139095040, !dbg !1077
  %461 = and i32 %458, 8388607, !dbg !1077
  %462 = icmp eq i32 %461, 0, !dbg !1077
  %is_inf93 = and i1 %460, %462, !dbg !1077
  %463 = bitcast float %453 to i32, !dbg !1077
  %464 = and i32 %463, 2147483647, !dbg !1077
  %is_maxfinite94 = icmp eq i32 %464, 2139095039, !dbg !1077
  %465 = bitcast float %453 to i32, !dbg !1077
  %466 = and i32 %465, -2147483648, !dbg !1077
  %467 = icmp eq i32 %466, 0, !dbg !1077
  %468 = icmp ne i32 %466, 0, !dbg !1077
  %is_pos_inf95 = and i1 %is_inf93, %467, !dbg !1077
  %is_neg_inf96 = and i1 %is_inf93, %468, !dbg !1077
  %is_pos_max97 = and i1 %is_maxfinite94, %467, !dbg !1077
  %is_neg_max98 = and i1 %is_maxfinite94, %468, !dbg !1077
  %overflow_cond99 = and i1 %457, %is_inf93, !dbg !1077
  br i1 %overflow_cond99, label %469, label %471, !dbg !1077

469:                                              ; preds = %452
  %470 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %471, !dbg !1077

471:                                              ; preds = %452, %469
  %472 = bitcast float %453 to i32, !dbg !1077
  %473 = bitcast float %453 to i32, !dbg !1077
  %474 = and i32 %473, 2139095040, !dbg !1077
  %475 = icmp eq i32 %474, 2139095040, !dbg !1077
  %476 = and i32 %473, 8388607, !dbg !1077
  %477 = icmp ne i32 %476, 0, !dbg !1077
  %is_nan100 = and i1 %475, %477, !dbg !1077
  %478 = and i32 %472, 4194304, !dbg !1077
  %479 = icmp eq i32 %478, 0, !dbg !1077
  %is_snan101 = and i1 %is_nan100, %479, !dbg !1077
  %480 = or i1 false, %is_snan101, !dbg !1077
  %481 = bitcast float %453 to i32, !dbg !1077
  %482 = and i32 %481, 2139095040, !dbg !1077
  %483 = icmp eq i32 %482, 2139095040, !dbg !1077
  %484 = and i32 %481, 8388607, !dbg !1077
  %485 = icmp eq i32 %484, 0, !dbg !1077
  %is_inf102 = and i1 %483, %485, !dbg !1077
  %486 = and i1 false, %is_inf102, !dbg !1077
  %487 = bitcast float %453 to i32, !dbg !1077
  %488 = and i32 %487, -2147483648, !dbg !1077
  %489 = icmp eq i32 -2147483648, %488, !dbg !1077
  %490 = and i1 %486, %489, !dbg !1077
  %491 = or i1 %480, %490, !dbg !1077
  br i1 %491, label %492, label %494, !dbg !1077

492:                                              ; preds = %471
  %493 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %494, !dbg !1077

494:                                              ; preds = %471, %492
  %495 = fsub float -0.000000e+00, %453, !dbg !1077
  %496 = bitcast float %453 to i32, !dbg !1077
  %497 = and i32 %496, 2139095040, !dbg !1077
  %is_finite103 = icmp ne i32 %497, 2139095040, !dbg !1077
  %498 = and i1 true, %is_finite103, !dbg !1077
  %499 = bitcast float %495 to i32, !dbg !1077
  %500 = and i32 %499, 2139095040, !dbg !1077
  %501 = icmp eq i32 %500, 2139095040, !dbg !1077
  %502 = and i32 %499, 8388607, !dbg !1077
  %503 = icmp eq i32 %502, 0, !dbg !1077
  %is_inf104 = and i1 %501, %503, !dbg !1077
  %504 = bitcast float %495 to i32, !dbg !1077
  %505 = and i32 %504, 2147483647, !dbg !1077
  %is_maxfinite105 = icmp eq i32 %505, 2139095039, !dbg !1077
  %506 = bitcast float %495 to i32, !dbg !1077
  %507 = and i32 %506, -2147483648, !dbg !1077
  %508 = icmp eq i32 %507, 0, !dbg !1077
  %509 = icmp ne i32 %507, 0, !dbg !1077
  %is_pos_inf106 = and i1 %is_inf104, %508, !dbg !1077
  %is_neg_inf107 = and i1 %is_inf104, %509, !dbg !1077
  %is_pos_max108 = and i1 %is_maxfinite105, %508, !dbg !1077
  %is_neg_max109 = and i1 %is_maxfinite105, %509, !dbg !1077
  %overflow_cond110 = and i1 %498, %is_inf104, !dbg !1077
  br i1 %overflow_cond110, label %510, label %512, !dbg !1077

510:                                              ; preds = %494
  %511 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %512, !dbg !1077

512:                                              ; preds = %494, %510
  %513 = bitcast float %308 to i32, !dbg !1077
  %514 = bitcast float %308 to i32, !dbg !1077
  %515 = and i32 %514, 2139095040, !dbg !1077
  %516 = icmp eq i32 %515, 2139095040, !dbg !1077
  %517 = and i32 %514, 8388607, !dbg !1077
  %518 = icmp ne i32 %517, 0, !dbg !1077
  %is_nan111 = and i1 %516, %518, !dbg !1077
  %519 = and i32 %513, 4194304, !dbg !1077
  %520 = icmp eq i32 %519, 0, !dbg !1077
  %is_snan112 = and i1 %is_nan111, %520, !dbg !1077
  %521 = or i1 %is_snan112, false, !dbg !1077
  %522 = bitcast float %495 to i32, !dbg !1077
  %523 = bitcast float %495 to i32, !dbg !1077
  %524 = and i32 %523, 2139095040, !dbg !1077
  %525 = icmp eq i32 %524, 2139095040, !dbg !1077
  %526 = and i32 %523, 8388607, !dbg !1077
  %527 = icmp ne i32 %526, 0, !dbg !1077
  %is_nan113 = and i1 %525, %527, !dbg !1077
  %528 = and i32 %522, 4194304, !dbg !1077
  %529 = icmp eq i32 %528, 0, !dbg !1077
  %is_snan114 = and i1 %is_nan113, %529, !dbg !1077
  %530 = or i1 %521, %is_snan114, !dbg !1077
  %531 = bitcast float %308 to i32, !dbg !1077
  %532 = and i32 %531, 2147483647, !dbg !1077
  %is_zero115 = icmp eq i32 %532, 0, !dbg !1077
  %533 = and i1 %is_zero115, false, !dbg !1077
  %534 = bitcast float %308 to i32, !dbg !1077
  %535 = and i32 %534, 2139095040, !dbg !1077
  %536 = icmp eq i32 %535, 2139095040, !dbg !1077
  %537 = and i32 %534, 8388607, !dbg !1077
  %538 = icmp eq i32 %537, 0, !dbg !1077
  %is_inf116 = and i1 %536, %538, !dbg !1077
  %539 = and i1 %is_inf116, false, !dbg !1077
  %540 = or i1 %533, %539, !dbg !1077
  %541 = or i1 %530, %540, !dbg !1077
  br i1 %541, label %542, label %544, !dbg !1077

542:                                              ; preds = %512
  %543 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %544, !dbg !1077

544:                                              ; preds = %512, %542
  %545 = call float @llvm.nvvm.fma.rn.f(float %308, float 0x3FF7154760000000, float %495) #5, !dbg !1077
  %546 = bitcast float %308 to i32, !dbg !1077
  %547 = and i32 %546, 2139095040, !dbg !1077
  %is_finite117 = icmp ne i32 %547, 2139095040, !dbg !1077
  %548 = and i1 true, %is_finite117, !dbg !1077
  %549 = and i1 %548, true, !dbg !1077
  %550 = bitcast float %545 to i32, !dbg !1077
  %551 = and i32 %550, 2139095040, !dbg !1077
  %552 = icmp eq i32 %551, 2139095040, !dbg !1077
  %553 = and i32 %550, 8388607, !dbg !1077
  %554 = icmp eq i32 %553, 0, !dbg !1077
  %is_inf118 = and i1 %552, %554, !dbg !1077
  %555 = bitcast float %545 to i32, !dbg !1077
  %556 = and i32 %555, 2147483647, !dbg !1077
  %is_maxfinite119 = icmp eq i32 %556, 2139095039, !dbg !1077
  %557 = bitcast float %545 to i32, !dbg !1077
  %558 = and i32 %557, -2147483648, !dbg !1077
  %559 = icmp eq i32 %558, 0, !dbg !1077
  %560 = icmp ne i32 %558, 0, !dbg !1077
  %is_pos_inf120 = and i1 %is_inf118, %559, !dbg !1077
  %is_neg_inf121 = and i1 %is_inf118, %560, !dbg !1077
  %is_pos_max122 = and i1 %is_maxfinite119, %559, !dbg !1077
  %is_neg_max123 = and i1 %is_maxfinite119, %560, !dbg !1077
  %overflow_cond124 = and i1 %549, %is_inf118, !dbg !1077
  br i1 %overflow_cond124, label %561, label %563, !dbg !1077

561:                                              ; preds = %544
  %562 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %563, !dbg !1077

563:                                              ; preds = %544, %561
  %564 = bitcast float %308 to i32, !dbg !1077
  %565 = and i32 %564, 2139095040, !dbg !1077
  %566 = icmp eq i32 %565, 0, !dbg !1077
  %567 = and i32 %564, 8388607, !dbg !1077
  %568 = icmp ne i32 %567, 0, !dbg !1077
  %is_subnormal125 = and i1 %566, %568, !dbg !1077
  %569 = xor i1 %is_subnormal125, true, !dbg !1077
  %570 = and i1 true, %569, !dbg !1077
  %571 = and i1 %570, true, !dbg !1077
  %572 = bitcast float %495 to i32, !dbg !1077
  %573 = and i32 %572, 2139095040, !dbg !1077
  %574 = icmp eq i32 %573, 0, !dbg !1077
  %575 = and i32 %572, 8388607, !dbg !1077
  %576 = icmp ne i32 %575, 0, !dbg !1077
  %is_subnormal126 = and i1 %574, %576, !dbg !1077
  %577 = xor i1 %is_subnormal126, true, !dbg !1077
  %578 = and i1 %571, %577, !dbg !1077
  %579 = bitcast float %545 to i32, !dbg !1077
  %580 = and i32 %579, 2139095040, !dbg !1077
  %581 = icmp eq i32 %580, 0, !dbg !1077
  %582 = and i32 %579, 8388607, !dbg !1077
  %583 = icmp ne i32 %582, 0, !dbg !1077
  %is_subnormal127 = and i1 %581, %583, !dbg !1077
  %is_tiny128 = or i1 %is_subnormal127, false, !dbg !1077
  %underflow_cond129 = and i1 %578, %is_tiny128, !dbg !1077
  br i1 %underflow_cond129, label %584, label %586, !dbg !1077

584:                                              ; preds = %563
  %585 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %586, !dbg !1077

586:                                              ; preds = %563, %584
  %587 = bitcast float %308 to i32, !dbg !1077
  %588 = bitcast float %308 to i32, !dbg !1077
  %589 = and i32 %588, 2139095040, !dbg !1077
  %590 = icmp eq i32 %589, 2139095040, !dbg !1077
  %591 = and i32 %588, 8388607, !dbg !1077
  %592 = icmp ne i32 %591, 0, !dbg !1077
  %is_nan130 = and i1 %590, %592, !dbg !1077
  %593 = and i32 %587, 4194304, !dbg !1077
  %594 = icmp eq i32 %593, 0, !dbg !1077
  %is_snan131 = and i1 %is_nan130, %594, !dbg !1077
  %595 = or i1 %is_snan131, false, !dbg !1077
  %596 = bitcast float %545 to i32, !dbg !1077
  %597 = bitcast float %545 to i32, !dbg !1077
  %598 = and i32 %597, 2139095040, !dbg !1077
  %599 = icmp eq i32 %598, 2139095040, !dbg !1077
  %600 = and i32 %597, 8388607, !dbg !1077
  %601 = icmp ne i32 %600, 0, !dbg !1077
  %is_nan132 = and i1 %599, %601, !dbg !1077
  %602 = and i32 %596, 4194304, !dbg !1077
  %603 = icmp eq i32 %602, 0, !dbg !1077
  %is_snan133 = and i1 %is_nan132, %603, !dbg !1077
  %604 = or i1 %595, %is_snan133, !dbg !1077
  %605 = bitcast float %308 to i32, !dbg !1077
  %606 = and i32 %605, 2147483647, !dbg !1077
  %is_zero134 = icmp eq i32 %606, 0, !dbg !1077
  %607 = and i1 %is_zero134, false, !dbg !1077
  %608 = bitcast float %308 to i32, !dbg !1077
  %609 = and i32 %608, 2139095040, !dbg !1077
  %610 = icmp eq i32 %609, 2139095040, !dbg !1077
  %611 = and i32 %608, 8388607, !dbg !1077
  %612 = icmp eq i32 %611, 0, !dbg !1077
  %is_inf135 = and i1 %610, %612, !dbg !1077
  %613 = and i1 %is_inf135, false, !dbg !1077
  %614 = or i1 %607, %613, !dbg !1077
  %615 = or i1 %604, %614, !dbg !1077
  br i1 %615, label %616, label %618, !dbg !1077

616:                                              ; preds = %586
  %617 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %618, !dbg !1077

618:                                              ; preds = %586, %616
  %619 = call float @llvm.nvvm.fma.rn.f(float %308, float 0x3E54AE0C00000000, float %545) #5, !dbg !1077
  %620 = bitcast float %308 to i32, !dbg !1077
  %621 = and i32 %620, 2139095040, !dbg !1077
  %is_finite136 = icmp ne i32 %621, 2139095040, !dbg !1077
  %622 = and i1 true, %is_finite136, !dbg !1077
  %623 = and i1 %622, true, !dbg !1077
  %624 = bitcast float %619 to i32, !dbg !1077
  %625 = and i32 %624, 2139095040, !dbg !1077
  %626 = icmp eq i32 %625, 2139095040, !dbg !1077
  %627 = and i32 %624, 8388607, !dbg !1077
  %628 = icmp eq i32 %627, 0, !dbg !1077
  %is_inf137 = and i1 %626, %628, !dbg !1077
  %629 = bitcast float %619 to i32, !dbg !1077
  %630 = and i32 %629, 2147483647, !dbg !1077
  %is_maxfinite138 = icmp eq i32 %630, 2139095039, !dbg !1077
  %631 = bitcast float %619 to i32, !dbg !1077
  %632 = and i32 %631, -2147483648, !dbg !1077
  %633 = icmp eq i32 %632, 0, !dbg !1077
  %634 = icmp ne i32 %632, 0, !dbg !1077
  %is_pos_inf139 = and i1 %is_inf137, %633, !dbg !1077
  %is_neg_inf140 = and i1 %is_inf137, %634, !dbg !1077
  %is_pos_max141 = and i1 %is_maxfinite138, %633, !dbg !1077
  %is_neg_max142 = and i1 %is_maxfinite138, %634, !dbg !1077
  %overflow_cond143 = and i1 %623, %is_inf137, !dbg !1077
  br i1 %overflow_cond143, label %635, label %637, !dbg !1077

635:                                              ; preds = %618
  %636 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %637, !dbg !1077

637:                                              ; preds = %618, %635
  %638 = bitcast float %308 to i32, !dbg !1077
  %639 = and i32 %638, 2139095040, !dbg !1077
  %640 = icmp eq i32 %639, 0, !dbg !1077
  %641 = and i32 %638, 8388607, !dbg !1077
  %642 = icmp ne i32 %641, 0, !dbg !1077
  %is_subnormal144 = and i1 %640, %642, !dbg !1077
  %643 = xor i1 %is_subnormal144, true, !dbg !1077
  %644 = and i1 true, %643, !dbg !1077
  %645 = and i1 %644, true, !dbg !1077
  %646 = bitcast float %545 to i32, !dbg !1077
  %647 = and i32 %646, 2139095040, !dbg !1077
  %648 = icmp eq i32 %647, 0, !dbg !1077
  %649 = and i32 %646, 8388607, !dbg !1077
  %650 = icmp ne i32 %649, 0, !dbg !1077
  %is_subnormal145 = and i1 %648, %650, !dbg !1077
  %651 = xor i1 %is_subnormal145, true, !dbg !1077
  %652 = and i1 %645, %651, !dbg !1077
  %653 = bitcast float %619 to i32, !dbg !1077
  %654 = and i32 %653, 2139095040, !dbg !1077
  %655 = icmp eq i32 %654, 0, !dbg !1077
  %656 = and i32 %653, 8388607, !dbg !1077
  %657 = icmp ne i32 %656, 0, !dbg !1077
  %is_subnormal146 = and i1 %655, %657, !dbg !1077
  %is_tiny147 = or i1 %is_subnormal146, false, !dbg !1077
  %underflow_cond148 = and i1 %652, %is_tiny147, !dbg !1077
  br i1 %underflow_cond148, label %658, label %660, !dbg !1077

658:                                              ; preds = %637
  %659 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %660, !dbg !1077

660:                                              ; preds = %637, %658
  %661 = bitcast float %394 to i32, !dbg !1077
  %662 = shl i32 %661, 23, !dbg !1077
  %663 = bitcast i32 %662 to float, !dbg !1077
  %664 = call float @llvm.nvvm.ex2.approx.ftz.f32(float %619), !dbg !1077
  %665 = bitcast float %664 to i32, !dbg !1077
  %666 = bitcast float %664 to i32, !dbg !1077
  %667 = and i32 %666, 2139095040, !dbg !1077
  %668 = icmp eq i32 %667, 2139095040, !dbg !1077
  %669 = and i32 %666, 8388607, !dbg !1077
  %670 = icmp ne i32 %669, 0, !dbg !1077
  %is_nan149 = and i1 %668, %670, !dbg !1077
  %671 = and i32 %665, 4194304, !dbg !1077
  %672 = icmp eq i32 %671, 0, !dbg !1077
  %is_snan150 = and i1 %is_nan149, %672, !dbg !1077
  %673 = bitcast float %663 to i32, !dbg !1077
  %674 = bitcast float %663 to i32, !dbg !1077
  %675 = and i32 %674, 2139095040, !dbg !1077
  %676 = icmp eq i32 %675, 2139095040, !dbg !1077
  %677 = and i32 %674, 8388607, !dbg !1077
  %678 = icmp ne i32 %677, 0, !dbg !1077
  %is_nan151 = and i1 %676, %678, !dbg !1077
  %679 = and i32 %673, 4194304, !dbg !1077
  %680 = icmp eq i32 %679, 0, !dbg !1077
  %is_snan152 = and i1 %is_nan151, %680, !dbg !1077
  %681 = or i1 %is_snan150, %is_snan152, !dbg !1077
  %682 = bitcast float %664 to i32, !dbg !1077
  %683 = and i32 %682, 2147483647, !dbg !1077
  %is_zero153 = icmp eq i32 %683, 0, !dbg !1077
  %684 = bitcast float %663 to i32, !dbg !1077
  %685 = and i32 %684, 2139095040, !dbg !1077
  %686 = icmp eq i32 %685, 2139095040, !dbg !1077
  %687 = and i32 %684, 8388607, !dbg !1077
  %688 = icmp eq i32 %687, 0, !dbg !1077
  %is_inf154 = and i1 %686, %688, !dbg !1077
  %689 = and i1 %is_zero153, %is_inf154, !dbg !1077
  %690 = bitcast float %664 to i32, !dbg !1077
  %691 = and i32 %690, 2139095040, !dbg !1077
  %692 = icmp eq i32 %691, 2139095040, !dbg !1077
  %693 = and i32 %690, 8388607, !dbg !1077
  %694 = icmp eq i32 %693, 0, !dbg !1077
  %is_inf155 = and i1 %692, %694, !dbg !1077
  %695 = bitcast float %663 to i32, !dbg !1077
  %696 = and i32 %695, 2147483647, !dbg !1077
  %is_zero156 = icmp eq i32 %696, 0, !dbg !1077
  %697 = and i1 %is_inf155, %is_zero156, !dbg !1077
  %698 = or i1 %689, %697, !dbg !1077
  %699 = or i1 %681, %698, !dbg !1077
  br i1 %699, label %700, label %702, !dbg !1077

700:                                              ; preds = %660
  %701 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1077
  br label %702, !dbg !1077

702:                                              ; preds = %660, %700
  %703 = fmul float %664, %663, !dbg !1077
  %704 = bitcast float %664 to i32, !dbg !1078
  %705 = and i32 %704, 2139095040, !dbg !1078
  %is_finite157 = icmp ne i32 %705, 2139095040, !dbg !1078
  %706 = and i1 true, %is_finite157, !dbg !1078
  %707 = bitcast float %663 to i32, !dbg !1078
  %708 = and i32 %707, 2139095040, !dbg !1078
  %is_finite158 = icmp ne i32 %708, 2139095040, !dbg !1078
  %709 = and i1 %706, %is_finite158, !dbg !1078
  %710 = bitcast float %703 to i32, !dbg !1078
  %711 = and i32 %710, 2139095040, !dbg !1078
  %712 = icmp eq i32 %711, 2139095040, !dbg !1078
  %713 = and i32 %710, 8388607, !dbg !1078
  %714 = icmp eq i32 %713, 0, !dbg !1078
  %is_inf159 = and i1 %712, %714, !dbg !1078
  %715 = bitcast float %703 to i32, !dbg !1078
  %716 = and i32 %715, 2147483647, !dbg !1078
  %is_maxfinite160 = icmp eq i32 %716, 2139095039, !dbg !1078
  %717 = bitcast float %703 to i32, !dbg !1078
  %718 = and i32 %717, -2147483648, !dbg !1078
  %719 = icmp eq i32 %718, 0, !dbg !1078
  %720 = icmp ne i32 %718, 0, !dbg !1078
  %is_pos_inf161 = and i1 %is_inf159, %719, !dbg !1078
  %is_neg_inf162 = and i1 %is_inf159, %720, !dbg !1078
  %is_pos_max163 = and i1 %is_maxfinite160, %719, !dbg !1078
  %is_neg_max164 = and i1 %is_maxfinite160, %720, !dbg !1078
  %overflow_cond165 = and i1 %709, %is_inf159, !dbg !1078
  br i1 %overflow_cond165, label %721, label %723, !dbg !1078

721:                                              ; preds = %702
  %722 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1078
  br label %723, !dbg !1078

723:                                              ; preds = %702, %721
  %724 = bitcast float %664 to i32, !dbg !1078
  %725 = and i32 %724, 2139095040, !dbg !1078
  %726 = icmp eq i32 %725, 0, !dbg !1078
  %727 = and i32 %724, 8388607, !dbg !1078
  %728 = icmp ne i32 %727, 0, !dbg !1078
  %is_subnormal166 = and i1 %726, %728, !dbg !1078
  %729 = xor i1 %is_subnormal166, true, !dbg !1078
  %730 = and i1 true, %729, !dbg !1078
  %731 = bitcast float %663 to i32, !dbg !1078
  %732 = and i32 %731, 2139095040, !dbg !1078
  %733 = icmp eq i32 %732, 0, !dbg !1078
  %734 = and i32 %731, 8388607, !dbg !1078
  %735 = icmp ne i32 %734, 0, !dbg !1078
  %is_subnormal167 = and i1 %733, %735, !dbg !1078
  %736 = xor i1 %is_subnormal167, true, !dbg !1078
  %737 = and i1 %730, %736, !dbg !1078
  %738 = bitcast float %703 to i32, !dbg !1078
  %739 = and i32 %738, 2139095040, !dbg !1078
  %740 = icmp eq i32 %739, 0, !dbg !1078
  %741 = and i32 %738, 8388607, !dbg !1078
  %742 = icmp ne i32 %741, 0, !dbg !1078
  %is_subnormal168 = and i1 %740, %742, !dbg !1078
  %743 = bitcast float %703 to i32, !dbg !1078
  %744 = and i32 %743, 2147483647, !dbg !1078
  %is_zero169 = icmp eq i32 %744, 0, !dbg !1078
  %745 = bitcast float %664 to i32, !dbg !1078
  %746 = and i32 %745, 2147483647, !dbg !1078
  %is_zero170 = icmp eq i32 %746, 0, !dbg !1078
  %747 = xor i1 %is_zero170, true, !dbg !1078
  %748 = bitcast float %663 to i32, !dbg !1078
  %749 = and i32 %748, 2147483647, !dbg !1078
  %is_zero171 = icmp eq i32 %749, 0, !dbg !1078
  %750 = xor i1 %is_zero171, true, !dbg !1078
  %751 = and i1 %747, %750, !dbg !1078
  %752 = and i1 %is_zero169, %751, !dbg !1078
  %is_tiny172 = or i1 %is_subnormal168, %752, !dbg !1078
  %underflow_cond173 = and i1 %737, %is_tiny172, !dbg !1078
  br i1 %underflow_cond173, label %753, label %755, !dbg !1078

753:                                              ; preds = %723
  %754 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1078
  br label %755, !dbg !1078

755:                                              ; preds = %723, %753
  %756 = load ptr, ptr %result.addr, align 8, !dbg !1078
  %arrayidx40 = getelementptr inbounds float, ptr %756, i64 5, !dbg !1078
  store float %703, ptr %arrayidx40, align 4, !dbg !1079
  %757 = load ptr, ptr %result.addr, align 8, !dbg !1080
  %arrayidx41 = getelementptr inbounds float, ptr %757, i64 5, !dbg !1080
  %758 = load float, ptr %arrayidx41, align 4, !dbg !1080
  %call42 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %758) #4, !dbg !1081
  %759 = zext i1 %call42 to i64, !dbg !1081
  %cond43 = select i1 %call42, i32 1, i32 0, !dbg !1081
  %760 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1082
  %arrayidx44 = getelementptr inbounds i32, ptr %760, i64 5, !dbg !1082
  store i32 %cond43, ptr %arrayidx44, align 4, !dbg !1083
  br label %if.end45, !dbg !1084

if.end45:                                         ; preds = %755, %if.end36
  %761 = load i32, ptr %idx, align 4, !dbg !1085
  %cmp46 = icmp eq i32 %761, 6, !dbg !1087
  br i1 %cmp46, label %if.then47, label %if.end54, !dbg !1087

if.then47:                                        ; preds = %if.end45
  store float 0x3FB99999A0000000, ptr %__a.addr.i66, align 4
    #dbg_declare(ptr %__a.addr.i66, !1088, !DIExpression(), !1089)
  store float 4.000000e+01, ptr %__b.addr.i, align 4
    #dbg_declare(ptr %__b.addr.i, !1092, !DIExpression(), !1093)
  %762 = load float, ptr %__a.addr.i66, align 4, !dbg !1094
  %763 = load float, ptr %__b.addr.i, align 4, !dbg !1095
  %764 = bitcast float %763 to i32, !dbg !1096
  %765 = bitcast float %763 to i32, !dbg !1096
  %766 = and i32 %765, 2139095040, !dbg !1096
  %767 = icmp eq i32 %766, 2139095040, !dbg !1096
  %768 = and i32 %765, 8388607, !dbg !1096
  %769 = icmp ne i32 %768, 0, !dbg !1096
  %is_nan174 = and i1 %767, %769, !dbg !1096
  %770 = and i32 %764, 4194304, !dbg !1096
  %771 = icmp eq i32 %770, 0, !dbg !1096
  %is_snan175 = and i1 %is_nan174, %771, !dbg !1096
  %772 = or i1 false, %is_snan175, !dbg !1096
  %773 = bitcast float %763 to i32, !dbg !1096
  %774 = and i32 %773, 2139095040, !dbg !1096
  %775 = icmp eq i32 %774, 2139095040, !dbg !1096
  %776 = and i32 %773, 8388607, !dbg !1096
  %777 = icmp eq i32 %776, 0, !dbg !1096
  %is_inf176 = and i1 %775, %777, !dbg !1096
  %778 = and i1 false, %is_inf176, !dbg !1096
  %779 = bitcast float %763 to i32, !dbg !1096
  %780 = and i32 %779, 2147483647, !dbg !1096
  %is_zero177 = icmp eq i32 %780, 0, !dbg !1096
  %781 = and i1 false, %is_zero177, !dbg !1096
  %782 = or i1 %778, %781, !dbg !1096
  %783 = or i1 %772, %782, !dbg !1096
  br i1 %783, label %784, label %786, !dbg !1096

784:                                              ; preds = %if.then47
  %785 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %786, !dbg !1096

786:                                              ; preds = %if.then47, %784
  %787 = fmul float 5.000000e-01, %763, !dbg !1096
  %788 = bitcast float %763 to i32, !dbg !1096
  %789 = and i32 %788, 2139095040, !dbg !1096
  %is_finite178 = icmp ne i32 %789, 2139095040, !dbg !1096
  %790 = and i1 true, %is_finite178, !dbg !1096
  %791 = bitcast float %787 to i32, !dbg !1096
  %792 = and i32 %791, 2139095040, !dbg !1096
  %793 = icmp eq i32 %792, 2139095040, !dbg !1096
  %794 = and i32 %791, 8388607, !dbg !1096
  %795 = icmp eq i32 %794, 0, !dbg !1096
  %is_inf179 = and i1 %793, %795, !dbg !1096
  %796 = bitcast float %787 to i32, !dbg !1096
  %797 = and i32 %796, 2147483647, !dbg !1096
  %is_maxfinite180 = icmp eq i32 %797, 2139095039, !dbg !1096
  %798 = bitcast float %787 to i32, !dbg !1096
  %799 = and i32 %798, -2147483648, !dbg !1096
  %800 = icmp eq i32 %799, 0, !dbg !1096
  %801 = icmp ne i32 %799, 0, !dbg !1096
  %is_pos_inf181 = and i1 %is_inf179, %800, !dbg !1096
  %is_neg_inf182 = and i1 %is_inf179, %801, !dbg !1096
  %is_pos_max183 = and i1 %is_maxfinite180, %800, !dbg !1096
  %is_neg_max184 = and i1 %is_maxfinite180, %801, !dbg !1096
  %overflow_cond185 = and i1 %790, %is_inf179, !dbg !1096
  br i1 %overflow_cond185, label %802, label %804, !dbg !1096

802:                                              ; preds = %786
  %803 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %804, !dbg !1096

804:                                              ; preds = %786, %802
  %805 = bitcast float %763 to i32, !dbg !1096
  %806 = and i32 %805, 2139095040, !dbg !1096
  %807 = icmp eq i32 %806, 0, !dbg !1096
  %808 = and i32 %805, 8388607, !dbg !1096
  %809 = icmp ne i32 %808, 0, !dbg !1096
  %is_subnormal186 = and i1 %807, %809, !dbg !1096
  %810 = xor i1 %is_subnormal186, true, !dbg !1096
  %811 = and i1 true, %810, !dbg !1096
  %812 = bitcast float %787 to i32, !dbg !1096
  %813 = and i32 %812, 2139095040, !dbg !1096
  %814 = icmp eq i32 %813, 0, !dbg !1096
  %815 = and i32 %812, 8388607, !dbg !1096
  %816 = icmp ne i32 %815, 0, !dbg !1096
  %is_subnormal187 = and i1 %814, %816, !dbg !1096
  %817 = bitcast float %787 to i32, !dbg !1096
  %818 = and i32 %817, 2147483647, !dbg !1096
  %is_zero188 = icmp eq i32 %818, 0, !dbg !1096
  %819 = bitcast float %763 to i32, !dbg !1096
  %820 = and i32 %819, 2147483647, !dbg !1096
  %is_zero189 = icmp eq i32 %820, 0, !dbg !1096
  %821 = xor i1 %is_zero189, true, !dbg !1096
  %822 = and i1 true, %821, !dbg !1096
  %823 = and i1 %is_zero188, %822, !dbg !1096
  %is_tiny190 = or i1 %is_subnormal187, %823, !dbg !1096
  %underflow_cond191 = and i1 %811, %is_tiny190, !dbg !1096
  br i1 %underflow_cond191, label %824, label %826, !dbg !1096

824:                                              ; preds = %804
  %825 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %826, !dbg !1096

826:                                              ; preds = %804, %824
  %827 = call float @llvm.nvvm.trunc.f(float %787) #5, !dbg !1096
  %828 = bitcast float %827 to i32, !dbg !1096
  %829 = bitcast float %827 to i32, !dbg !1096
  %830 = and i32 %829, 2139095040, !dbg !1096
  %831 = icmp eq i32 %830, 2139095040, !dbg !1096
  %832 = and i32 %829, 8388607, !dbg !1096
  %833 = icmp ne i32 %832, 0, !dbg !1096
  %is_nan192 = and i1 %831, %833, !dbg !1096
  %834 = and i32 %828, 4194304, !dbg !1096
  %835 = icmp eq i32 %834, 0, !dbg !1096
  %is_snan193 = and i1 %is_nan192, %835, !dbg !1096
  %836 = or i1 false, %is_snan193, !dbg !1096
  %837 = bitcast float %827 to i32, !dbg !1096
  %838 = and i32 %837, 2139095040, !dbg !1096
  %839 = icmp eq i32 %838, 2139095040, !dbg !1096
  %840 = and i32 %837, 8388607, !dbg !1096
  %841 = icmp eq i32 %840, 0, !dbg !1096
  %is_inf194 = and i1 %839, %841, !dbg !1096
  %842 = and i1 false, %is_inf194, !dbg !1096
  %843 = bitcast float %827 to i32, !dbg !1096
  %844 = and i32 %843, 2147483647, !dbg !1096
  %is_zero195 = icmp eq i32 %844, 0, !dbg !1096
  %845 = and i1 false, %is_zero195, !dbg !1096
  %846 = or i1 %842, %845, !dbg !1096
  %847 = or i1 %836, %846, !dbg !1096
  br i1 %847, label %848, label %850, !dbg !1096

848:                                              ; preds = %826
  %849 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %850, !dbg !1096

850:                                              ; preds = %826, %848
  %851 = fmul float 2.000000e+00, %827, !dbg !1096
  %852 = bitcast float %827 to i32, !dbg !1096
  %853 = and i32 %852, 2139095040, !dbg !1096
  %is_finite196 = icmp ne i32 %853, 2139095040, !dbg !1096
  %854 = and i1 true, %is_finite196, !dbg !1096
  %855 = bitcast float %851 to i32, !dbg !1096
  %856 = and i32 %855, 2139095040, !dbg !1096
  %857 = icmp eq i32 %856, 2139095040, !dbg !1096
  %858 = and i32 %855, 8388607, !dbg !1096
  %859 = icmp eq i32 %858, 0, !dbg !1096
  %is_inf197 = and i1 %857, %859, !dbg !1096
  %860 = bitcast float %851 to i32, !dbg !1096
  %861 = and i32 %860, 2147483647, !dbg !1096
  %is_maxfinite198 = icmp eq i32 %861, 2139095039, !dbg !1096
  %862 = bitcast float %851 to i32, !dbg !1096
  %863 = and i32 %862, -2147483648, !dbg !1096
  %864 = icmp eq i32 %863, 0, !dbg !1096
  %865 = icmp ne i32 %863, 0, !dbg !1096
  %is_pos_inf199 = and i1 %is_inf197, %864, !dbg !1096
  %is_neg_inf200 = and i1 %is_inf197, %865, !dbg !1096
  %is_pos_max201 = and i1 %is_maxfinite198, %864, !dbg !1096
  %is_neg_max202 = and i1 %is_maxfinite198, %865, !dbg !1096
  %overflow_cond203 = and i1 %854, %is_inf197, !dbg !1096
  br i1 %overflow_cond203, label %866, label %868, !dbg !1096

866:                                              ; preds = %850
  %867 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %868, !dbg !1096

868:                                              ; preds = %850, %866
  %869 = bitcast float %827 to i32, !dbg !1096
  %870 = and i32 %869, 2139095040, !dbg !1096
  %871 = icmp eq i32 %870, 0, !dbg !1096
  %872 = and i32 %869, 8388607, !dbg !1096
  %873 = icmp ne i32 %872, 0, !dbg !1096
  %is_subnormal204 = and i1 %871, %873, !dbg !1096
  %874 = xor i1 %is_subnormal204, true, !dbg !1096
  %875 = and i1 true, %874, !dbg !1096
  %876 = bitcast float %851 to i32, !dbg !1096
  %877 = and i32 %876, 2139095040, !dbg !1096
  %878 = icmp eq i32 %877, 0, !dbg !1096
  %879 = and i32 %876, 8388607, !dbg !1096
  %880 = icmp ne i32 %879, 0, !dbg !1096
  %is_subnormal205 = and i1 %878, %880, !dbg !1096
  %881 = bitcast float %851 to i32, !dbg !1096
  %882 = and i32 %881, 2147483647, !dbg !1096
  %is_zero206 = icmp eq i32 %882, 0, !dbg !1096
  %883 = bitcast float %827 to i32, !dbg !1096
  %884 = and i32 %883, 2147483647, !dbg !1096
  %is_zero207 = icmp eq i32 %884, 0, !dbg !1096
  %885 = xor i1 %is_zero207, true, !dbg !1096
  %886 = and i1 true, %885, !dbg !1096
  %887 = and i1 %is_zero206, %886, !dbg !1096
  %is_tiny208 = or i1 %is_subnormal205, %887, !dbg !1096
  %underflow_cond209 = and i1 %875, %is_tiny208, !dbg !1096
  br i1 %underflow_cond209, label %888, label %890, !dbg !1096

888:                                              ; preds = %868
  %889 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %890, !dbg !1096

890:                                              ; preds = %868, %888
  %891 = bitcast float %763 to i32, !dbg !1096
  %892 = bitcast float %763 to i32, !dbg !1096
  %893 = and i32 %892, 2139095040, !dbg !1096
  %894 = icmp eq i32 %893, 2139095040, !dbg !1096
  %895 = and i32 %892, 8388607, !dbg !1096
  %896 = icmp ne i32 %895, 0, !dbg !1096
  %is_nan210 = and i1 %894, %896, !dbg !1096
  %897 = and i32 %891, 4194304, !dbg !1096
  %898 = icmp eq i32 %897, 0, !dbg !1096
  %is_snan211 = and i1 %is_nan210, %898, !dbg !1096
  %899 = bitcast float %851 to i32, !dbg !1096
  %900 = bitcast float %851 to i32, !dbg !1096
  %901 = and i32 %900, 2139095040, !dbg !1096
  %902 = icmp eq i32 %901, 2139095040, !dbg !1096
  %903 = and i32 %900, 8388607, !dbg !1096
  %904 = icmp ne i32 %903, 0, !dbg !1096
  %is_nan212 = and i1 %902, %904, !dbg !1096
  %905 = and i32 %899, 4194304, !dbg !1096
  %906 = icmp eq i32 %905, 0, !dbg !1096
  %is_snan213 = and i1 %is_nan212, %906, !dbg !1096
  %907 = or i1 %is_snan211, %is_snan213, !dbg !1096
  %908 = bitcast float %763 to i32, !dbg !1096
  %909 = and i32 %908, 2139095040, !dbg !1096
  %910 = icmp eq i32 %909, 2139095040, !dbg !1096
  %911 = and i32 %908, 8388607, !dbg !1096
  %912 = icmp eq i32 %911, 0, !dbg !1096
  %is_inf214 = and i1 %910, %912, !dbg !1096
  %913 = bitcast float %851 to i32, !dbg !1096
  %914 = and i32 %913, 2139095040, !dbg !1096
  %915 = icmp eq i32 %914, 2139095040, !dbg !1096
  %916 = and i32 %913, 8388607, !dbg !1096
  %917 = icmp eq i32 %916, 0, !dbg !1096
  %is_inf215 = and i1 %915, %917, !dbg !1096
  %918 = and i1 %is_inf214, %is_inf215, !dbg !1096
  %919 = bitcast float %763 to i32, !dbg !1096
  %920 = bitcast float %851 to i32, !dbg !1096
  %921 = and i32 %919, -2147483648, !dbg !1096
  %922 = and i32 %920, -2147483648, !dbg !1096
  %923 = icmp eq i32 %921, %922, !dbg !1096
  %924 = and i1 %918, %923, !dbg !1096
  %925 = or i1 %907, %924, !dbg !1096
  br i1 %925, label %926, label %928, !dbg !1096

926:                                              ; preds = %890
  %927 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %928, !dbg !1096

928:                                              ; preds = %890, %926
  %929 = fsub float %763, %851, !dbg !1096
  %930 = bitcast float %763 to i32, !dbg !1096
  %931 = and i32 %930, 2139095040, !dbg !1096
  %is_finite216 = icmp ne i32 %931, 2139095040, !dbg !1096
  %932 = and i1 true, %is_finite216, !dbg !1096
  %933 = bitcast float %851 to i32, !dbg !1096
  %934 = and i32 %933, 2139095040, !dbg !1096
  %is_finite217 = icmp ne i32 %934, 2139095040, !dbg !1096
  %935 = and i1 %932, %is_finite217, !dbg !1096
  %936 = bitcast float %929 to i32, !dbg !1096
  %937 = and i32 %936, 2139095040, !dbg !1096
  %938 = icmp eq i32 %937, 2139095040, !dbg !1096
  %939 = and i32 %936, 8388607, !dbg !1096
  %940 = icmp eq i32 %939, 0, !dbg !1096
  %is_inf218 = and i1 %938, %940, !dbg !1096
  %941 = bitcast float %929 to i32, !dbg !1096
  %942 = and i32 %941, 2147483647, !dbg !1096
  %is_maxfinite219 = icmp eq i32 %942, 2139095039, !dbg !1096
  %943 = bitcast float %929 to i32, !dbg !1096
  %944 = and i32 %943, -2147483648, !dbg !1096
  %945 = icmp eq i32 %944, 0, !dbg !1096
  %946 = icmp ne i32 %944, 0, !dbg !1096
  %is_pos_inf220 = and i1 %is_inf218, %945, !dbg !1096
  %is_neg_inf221 = and i1 %is_inf218, %946, !dbg !1096
  %is_pos_max222 = and i1 %is_maxfinite219, %945, !dbg !1096
  %is_neg_max223 = and i1 %is_maxfinite219, %946, !dbg !1096
  %overflow_cond224 = and i1 %935, %is_inf218, !dbg !1096
  br i1 %overflow_cond224, label %947, label %949, !dbg !1096

947:                                              ; preds = %928
  %948 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %949, !dbg !1096

949:                                              ; preds = %928, %947
  %950 = call float @llvm.nvvm.fabs.f32(float %929), !dbg !1096
  %951 = fcmp oeq float %950, 1.000000e+00, !dbg !1096
  %952 = select i1 %951, i32 1, i32 0, !dbg !1096
  %953 = call float @llvm.nvvm.fabs.f32(float %762), !dbg !1096
  %954 = fcmp olt float %953, 0x3810000000000000, !dbg !1096
  br i1 %954, label %955, label %1021, !dbg !1096

955:                                              ; preds = %949
  %956 = bitcast float %953 to i32, !dbg !1096
  %957 = bitcast float %953 to i32, !dbg !1096
  %958 = and i32 %957, 2139095040, !dbg !1096
  %959 = icmp eq i32 %958, 2139095040, !dbg !1096
  %960 = and i32 %957, 8388607, !dbg !1096
  %961 = icmp ne i32 %960, 0, !dbg !1096
  %is_nan225 = and i1 %959, %961, !dbg !1096
  %962 = and i32 %956, 4194304, !dbg !1096
  %963 = icmp eq i32 %962, 0, !dbg !1096
  %is_snan226 = and i1 %is_nan225, %963, !dbg !1096
  %964 = or i1 %is_snan226, false, !dbg !1096
  %965 = bitcast float %953 to i32, !dbg !1096
  %966 = and i32 %965, 2147483647, !dbg !1096
  %is_zero227 = icmp eq i32 %966, 0, !dbg !1096
  %967 = and i1 %is_zero227, false, !dbg !1096
  %968 = bitcast float %953 to i32, !dbg !1096
  %969 = and i32 %968, 2139095040, !dbg !1096
  %970 = icmp eq i32 %969, 2139095040, !dbg !1096
  %971 = and i32 %968, 8388607, !dbg !1096
  %972 = icmp eq i32 %971, 0, !dbg !1096
  %is_inf228 = and i1 %970, %972, !dbg !1096
  %973 = and i1 %is_inf228, false, !dbg !1096
  %974 = or i1 %967, %973, !dbg !1096
  %975 = or i1 %964, %974, !dbg !1096
  br i1 %975, label %976, label %978, !dbg !1096

976:                                              ; preds = %955
  %977 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %978, !dbg !1096

978:                                              ; preds = %955, %976
  %979 = fmul float %953, 0x4170000000000000, !dbg !1096
  %980 = bitcast float %953 to i32, !dbg !1096
  %981 = and i32 %980, 2139095040, !dbg !1096
  %is_finite229 = icmp ne i32 %981, 2139095040, !dbg !1096
  %982 = and i1 true, %is_finite229, !dbg !1096
  %983 = and i1 %982, true, !dbg !1096
  %984 = bitcast float %979 to i32, !dbg !1096
  %985 = and i32 %984, 2139095040, !dbg !1096
  %986 = icmp eq i32 %985, 2139095040, !dbg !1096
  %987 = and i32 %984, 8388607, !dbg !1096
  %988 = icmp eq i32 %987, 0, !dbg !1096
  %is_inf230 = and i1 %986, %988, !dbg !1096
  %989 = bitcast float %979 to i32, !dbg !1096
  %990 = and i32 %989, 2147483647, !dbg !1096
  %is_maxfinite231 = icmp eq i32 %990, 2139095039, !dbg !1096
  %991 = bitcast float %979 to i32, !dbg !1096
  %992 = and i32 %991, -2147483648, !dbg !1096
  %993 = icmp eq i32 %992, 0, !dbg !1096
  %994 = icmp ne i32 %992, 0, !dbg !1096
  %is_pos_inf232 = and i1 %is_inf230, %993, !dbg !1096
  %is_neg_inf233 = and i1 %is_inf230, %994, !dbg !1096
  %is_pos_max234 = and i1 %is_maxfinite231, %993, !dbg !1096
  %is_neg_max235 = and i1 %is_maxfinite231, %994, !dbg !1096
  %overflow_cond236 = and i1 %983, %is_inf230, !dbg !1096
  br i1 %overflow_cond236, label %995, label %997, !dbg !1096

995:                                              ; preds = %978
  %996 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %997, !dbg !1096

997:                                              ; preds = %978, %995
  %998 = bitcast float %953 to i32, !dbg !1096
  %999 = and i32 %998, 2139095040, !dbg !1096
  %1000 = icmp eq i32 %999, 0, !dbg !1096
  %1001 = and i32 %998, 8388607, !dbg !1096
  %1002 = icmp ne i32 %1001, 0, !dbg !1096
  %is_subnormal237 = and i1 %1000, %1002, !dbg !1096
  %1003 = xor i1 %is_subnormal237, true, !dbg !1096
  %1004 = and i1 true, %1003, !dbg !1096
  %1005 = and i1 %1004, true, !dbg !1096
  %1006 = bitcast float %979 to i32, !dbg !1096
  %1007 = and i32 %1006, 2139095040, !dbg !1096
  %1008 = icmp eq i32 %1007, 0, !dbg !1096
  %1009 = and i32 %1006, 8388607, !dbg !1096
  %1010 = icmp ne i32 %1009, 0, !dbg !1096
  %is_subnormal238 = and i1 %1008, %1010, !dbg !1096
  %1011 = bitcast float %979 to i32, !dbg !1096
  %1012 = and i32 %1011, 2147483647, !dbg !1096
  %is_zero239 = icmp eq i32 %1012, 0, !dbg !1096
  %1013 = bitcast float %953 to i32, !dbg !1096
  %1014 = and i32 %1013, 2147483647, !dbg !1096
  %is_zero240 = icmp eq i32 %1014, 0, !dbg !1096
  %1015 = xor i1 %is_zero240, true, !dbg !1096
  %1016 = and i1 %1015, true, !dbg !1096
  %1017 = and i1 %is_zero239, %1016, !dbg !1096
  %is_tiny241 = or i1 %is_subnormal238, %1017, !dbg !1096
  %underflow_cond242 = and i1 %1005, %is_tiny241, !dbg !1096
  br i1 %underflow_cond242, label %1018, label %1020, !dbg !1096

1018:                                             ; preds = %997
  %1019 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1020, !dbg !1096

1020:                                             ; preds = %997, %1018
  br label %1021, !dbg !1096

1021:                                             ; preds = %1020, %949
  %.013.i = phi float [ %979, %1020 ], [ %953, %949 ], !dbg !1096
  %expo.i.i.0.i = phi float [ -2.400000e+01, %1020 ], [ 0.000000e+00, %949 ], !dbg !1096
  %1022 = bitcast float %.013.i to i32, !dbg !1096
  %1023 = sub i32 %1022, 1060439283, !dbg !1096
  %1024 = and i32 %1023, -8388608, !dbg !1096
  %1025 = bitcast float %.013.i to i32, !dbg !1096
  %1026 = sub i32 %1025, %1024, !dbg !1096
  %1027 = bitcast i32 %1026 to float, !dbg !1096
  %1028 = sitofp i32 %1024 to float, !dbg !1096
  %1029 = bitcast float %1028 to i32, !dbg !1096
  %1030 = bitcast float %1028 to i32, !dbg !1096
  %1031 = and i32 %1030, 2139095040, !dbg !1096
  %1032 = icmp eq i32 %1031, 2139095040, !dbg !1096
  %1033 = and i32 %1030, 8388607, !dbg !1096
  %1034 = icmp ne i32 %1033, 0, !dbg !1096
  %is_nan243 = and i1 %1032, %1034, !dbg !1096
  %1035 = and i32 %1029, 4194304, !dbg !1096
  %1036 = icmp eq i32 %1035, 0, !dbg !1096
  %is_snan244 = and i1 %is_nan243, %1036, !dbg !1096
  %1037 = or i1 %is_snan244, false, !dbg !1096
  %1038 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1039 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1040 = and i32 %1039, 2139095040, !dbg !1096
  %1041 = icmp eq i32 %1040, 2139095040, !dbg !1096
  %1042 = and i32 %1039, 8388607, !dbg !1096
  %1043 = icmp ne i32 %1042, 0, !dbg !1096
  %is_nan245 = and i1 %1041, %1043, !dbg !1096
  %1044 = and i32 %1038, 4194304, !dbg !1096
  %1045 = icmp eq i32 %1044, 0, !dbg !1096
  %is_snan246 = and i1 %is_nan245, %1045, !dbg !1096
  %1046 = or i1 %1037, %is_snan246, !dbg !1096
  %1047 = bitcast float %1028 to i32, !dbg !1096
  %1048 = and i32 %1047, 2147483647, !dbg !1096
  %is_zero247 = icmp eq i32 %1048, 0, !dbg !1096
  %1049 = and i1 %is_zero247, false, !dbg !1096
  %1050 = bitcast float %1028 to i32, !dbg !1096
  %1051 = and i32 %1050, 2139095040, !dbg !1096
  %1052 = icmp eq i32 %1051, 2139095040, !dbg !1096
  %1053 = and i32 %1050, 8388607, !dbg !1096
  %1054 = icmp eq i32 %1053, 0, !dbg !1096
  %is_inf248 = and i1 %1052, %1054, !dbg !1096
  %1055 = and i1 %is_inf248, false, !dbg !1096
  %1056 = or i1 %1049, %1055, !dbg !1096
  %1057 = or i1 %1046, %1056, !dbg !1096
  br i1 %1057, label %1058, label %1060, !dbg !1096

1058:                                             ; preds = %1021
  %1059 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1060, !dbg !1096

1060:                                             ; preds = %1021, %1058
  %1061 = call float @llvm.nvvm.fma.rn.f(float %1028, float 0x3E80000000000000, float %expo.i.i.0.i) #5, !dbg !1096
  %1062 = bitcast float %1028 to i32, !dbg !1096
  %1063 = and i32 %1062, 2139095040, !dbg !1096
  %is_finite249 = icmp ne i32 %1063, 2139095040, !dbg !1096
  %1064 = and i1 true, %is_finite249, !dbg !1096
  %1065 = and i1 %1064, true, !dbg !1096
  %1066 = bitcast float %1061 to i32, !dbg !1096
  %1067 = and i32 %1066, 2139095040, !dbg !1096
  %1068 = icmp eq i32 %1067, 2139095040, !dbg !1096
  %1069 = and i32 %1066, 8388607, !dbg !1096
  %1070 = icmp eq i32 %1069, 0, !dbg !1096
  %is_inf250 = and i1 %1068, %1070, !dbg !1096
  %1071 = bitcast float %1061 to i32, !dbg !1096
  %1072 = and i32 %1071, 2147483647, !dbg !1096
  %is_maxfinite251 = icmp eq i32 %1072, 2139095039, !dbg !1096
  %1073 = bitcast float %1061 to i32, !dbg !1096
  %1074 = and i32 %1073, -2147483648, !dbg !1096
  %1075 = icmp eq i32 %1074, 0, !dbg !1096
  %1076 = icmp ne i32 %1074, 0, !dbg !1096
  %is_pos_inf252 = and i1 %is_inf250, %1075, !dbg !1096
  %is_neg_inf253 = and i1 %is_inf250, %1076, !dbg !1096
  %is_pos_max254 = and i1 %is_maxfinite251, %1075, !dbg !1096
  %is_neg_max255 = and i1 %is_maxfinite251, %1076, !dbg !1096
  %overflow_cond256 = and i1 %1065, %is_inf250, !dbg !1096
  br i1 %overflow_cond256, label %1077, label %1079, !dbg !1096

1077:                                             ; preds = %1060
  %1078 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1079, !dbg !1096

1079:                                             ; preds = %1060, %1077
  %1080 = bitcast float %1028 to i32, !dbg !1096
  %1081 = and i32 %1080, 2139095040, !dbg !1096
  %1082 = icmp eq i32 %1081, 0, !dbg !1096
  %1083 = and i32 %1080, 8388607, !dbg !1096
  %1084 = icmp ne i32 %1083, 0, !dbg !1096
  %is_subnormal257 = and i1 %1082, %1084, !dbg !1096
  %1085 = xor i1 %is_subnormal257, true, !dbg !1096
  %1086 = and i1 true, %1085, !dbg !1096
  %1087 = and i1 %1086, true, !dbg !1096
  %1088 = bitcast float %expo.i.i.0.i to i32, !dbg !1096
  %1089 = and i32 %1088, 2139095040, !dbg !1096
  %1090 = icmp eq i32 %1089, 0, !dbg !1096
  %1091 = and i32 %1088, 8388607, !dbg !1096
  %1092 = icmp ne i32 %1091, 0, !dbg !1096
  %is_subnormal258 = and i1 %1090, %1092, !dbg !1096
  %1093 = xor i1 %is_subnormal258, true, !dbg !1096
  %1094 = and i1 %1087, %1093, !dbg !1096
  %1095 = bitcast float %1061 to i32, !dbg !1096
  %1096 = and i32 %1095, 2139095040, !dbg !1096
  %1097 = icmp eq i32 %1096, 0, !dbg !1096
  %1098 = and i32 %1095, 8388607, !dbg !1096
  %1099 = icmp ne i32 %1098, 0, !dbg !1096
  %is_subnormal259 = and i1 %1097, %1099, !dbg !1096
  %is_tiny260 = or i1 %is_subnormal259, false, !dbg !1096
  %underflow_cond261 = and i1 %1094, %is_tiny260, !dbg !1096
  br i1 %underflow_cond261, label %1100, label %1102, !dbg !1096

1100:                                             ; preds = %1079
  %1101 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1102, !dbg !1096

1102:                                             ; preds = %1079, %1100
  %1103 = bitcast float %1027 to i32, !dbg !1096
  %1104 = bitcast float %1027 to i32, !dbg !1096
  %1105 = and i32 %1104, 2139095040, !dbg !1096
  %1106 = icmp eq i32 %1105, 2139095040, !dbg !1096
  %1107 = and i32 %1104, 8388607, !dbg !1096
  %1108 = icmp ne i32 %1107, 0, !dbg !1096
  %is_nan262 = and i1 %1106, %1108, !dbg !1096
  %1109 = and i32 %1103, 4194304, !dbg !1096
  %1110 = icmp eq i32 %1109, 0, !dbg !1096
  %is_snan263 = and i1 %is_nan262, %1110, !dbg !1096
  %1111 = or i1 %is_snan263, false, !dbg !1096
  %1112 = bitcast float %1027 to i32, !dbg !1096
  %1113 = and i32 %1112, 2139095040, !dbg !1096
  %1114 = icmp eq i32 %1113, 2139095040, !dbg !1096
  %1115 = and i32 %1112, 8388607, !dbg !1096
  %1116 = icmp eq i32 %1115, 0, !dbg !1096
  %is_inf264 = and i1 %1114, %1116, !dbg !1096
  %1117 = and i1 %is_inf264, false, !dbg !1096
  %1118 = bitcast float %1027 to i32, !dbg !1096
  %1119 = and i32 %1118, -2147483648, !dbg !1096
  %1120 = icmp eq i32 %1119, 0, !dbg !1096
  %1121 = and i1 %1117, %1120, !dbg !1096
  %1122 = or i1 %1111, %1121, !dbg !1096
  br i1 %1122, label %1123, label %1125, !dbg !1096

1123:                                             ; preds = %1102
  %1124 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1125, !dbg !1096

1125:                                             ; preds = %1102, %1123
  %1126 = fsub float %1027, 1.000000e+00, !dbg !1096
  %1127 = bitcast float %1027 to i32, !dbg !1096
  %1128 = and i32 %1127, 2139095040, !dbg !1096
  %is_finite265 = icmp ne i32 %1128, 2139095040, !dbg !1096
  %1129 = and i1 true, %is_finite265, !dbg !1096
  %1130 = and i1 %1129, true, !dbg !1096
  %1131 = bitcast float %1126 to i32, !dbg !1096
  %1132 = and i32 %1131, 2139095040, !dbg !1096
  %1133 = icmp eq i32 %1132, 2139095040, !dbg !1096
  %1134 = and i32 %1131, 8388607, !dbg !1096
  %1135 = icmp eq i32 %1134, 0, !dbg !1096
  %is_inf266 = and i1 %1133, %1135, !dbg !1096
  %1136 = bitcast float %1126 to i32, !dbg !1096
  %1137 = and i32 %1136, 2147483647, !dbg !1096
  %is_maxfinite267 = icmp eq i32 %1137, 2139095039, !dbg !1096
  %1138 = bitcast float %1126 to i32, !dbg !1096
  %1139 = and i32 %1138, -2147483648, !dbg !1096
  %1140 = icmp eq i32 %1139, 0, !dbg !1096
  %1141 = icmp ne i32 %1139, 0, !dbg !1096
  %is_pos_inf268 = and i1 %is_inf266, %1140, !dbg !1096
  %is_neg_inf269 = and i1 %is_inf266, %1141, !dbg !1096
  %is_pos_max270 = and i1 %is_maxfinite267, %1140, !dbg !1096
  %is_neg_max271 = and i1 %is_maxfinite267, %1141, !dbg !1096
  %overflow_cond272 = and i1 %1130, %is_inf266, !dbg !1096
  br i1 %overflow_cond272, label %1142, label %1144, !dbg !1096

1142:                                             ; preds = %1125
  %1143 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1144, !dbg !1096

1144:                                             ; preds = %1125, %1142
  %1145 = bitcast float %1027 to i32, !dbg !1096
  %1146 = bitcast float %1027 to i32, !dbg !1096
  %1147 = and i32 %1146, 2139095040, !dbg !1096
  %1148 = icmp eq i32 %1147, 2139095040, !dbg !1096
  %1149 = and i32 %1146, 8388607, !dbg !1096
  %1150 = icmp ne i32 %1149, 0, !dbg !1096
  %is_nan273 = and i1 %1148, %1150, !dbg !1096
  %1151 = and i32 %1145, 4194304, !dbg !1096
  %1152 = icmp eq i32 %1151, 0, !dbg !1096
  %is_snan274 = and i1 %is_nan273, %1152, !dbg !1096
  %1153 = or i1 %is_snan274, false, !dbg !1096
  %1154 = bitcast float %1027 to i32, !dbg !1096
  %1155 = and i32 %1154, 2139095040, !dbg !1096
  %1156 = icmp eq i32 %1155, 2139095040, !dbg !1096
  %1157 = and i32 %1154, 8388607, !dbg !1096
  %1158 = icmp eq i32 %1157, 0, !dbg !1096
  %is_inf275 = and i1 %1156, %1158, !dbg !1096
  %1159 = and i1 %is_inf275, false, !dbg !1096
  %1160 = bitcast float %1027 to i32, !dbg !1096
  %1161 = and i32 %1160, -2147483648, !dbg !1096
  %1162 = icmp ne i32 %1161, 0, !dbg !1096
  %1163 = and i1 %1159, %1162, !dbg !1096
  %1164 = or i1 %1153, %1163, !dbg !1096
  br i1 %1164, label %1165, label %1167, !dbg !1096

1165:                                             ; preds = %1144
  %1166 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1167, !dbg !1096

1167:                                             ; preds = %1144, %1165
  %1168 = fadd float %1027, 1.000000e+00, !dbg !1096
  %1169 = bitcast float %1027 to i32, !dbg !1096
  %1170 = and i32 %1169, 2139095040, !dbg !1096
  %is_finite276 = icmp ne i32 %1170, 2139095040, !dbg !1096
  %1171 = and i1 true, %is_finite276, !dbg !1096
  %1172 = and i1 %1171, true, !dbg !1096
  %1173 = bitcast float %1168 to i32, !dbg !1096
  %1174 = and i32 %1173, 2139095040, !dbg !1096
  %1175 = icmp eq i32 %1174, 2139095040, !dbg !1096
  %1176 = and i32 %1173, 8388607, !dbg !1096
  %1177 = icmp eq i32 %1176, 0, !dbg !1096
  %is_inf277 = and i1 %1175, %1177, !dbg !1096
  %1178 = bitcast float %1168 to i32, !dbg !1096
  %1179 = and i32 %1178, 2147483647, !dbg !1096
  %is_maxfinite278 = icmp eq i32 %1179, 2139095039, !dbg !1096
  %1180 = bitcast float %1168 to i32, !dbg !1096
  %1181 = and i32 %1180, -2147483648, !dbg !1096
  %1182 = icmp eq i32 %1181, 0, !dbg !1096
  %1183 = icmp ne i32 %1181, 0, !dbg !1096
  %is_pos_inf279 = and i1 %is_inf277, %1182, !dbg !1096
  %is_neg_inf280 = and i1 %is_inf277, %1183, !dbg !1096
  %is_pos_max281 = and i1 %is_maxfinite278, %1182, !dbg !1096
  %is_neg_max282 = and i1 %is_maxfinite278, %1183, !dbg !1096
  %overflow_cond283 = and i1 %1172, %is_inf277, !dbg !1096
  br i1 %overflow_cond283, label %1184, label %1186, !dbg !1096

1184:                                             ; preds = %1167
  %1185 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1186, !dbg !1096

1186:                                             ; preds = %1167, %1184
  %1187 = call float asm "rcp.approx.ftz.f32 $0,$1;", "=f,f"(float %1168) #6, !dbg !1096, !srcloc !1097
  %1188 = bitcast float %1126 to i32, !dbg !1096
  %1189 = bitcast float %1126 to i32, !dbg !1096
  %1190 = and i32 %1189, 2139095040, !dbg !1096
  %1191 = icmp eq i32 %1190, 2139095040, !dbg !1096
  %1192 = and i32 %1189, 8388607, !dbg !1096
  %1193 = icmp ne i32 %1192, 0, !dbg !1096
  %is_nan284 = and i1 %1191, %1193, !dbg !1096
  %1194 = and i32 %1188, 4194304, !dbg !1096
  %1195 = icmp eq i32 %1194, 0, !dbg !1096
  %is_snan285 = and i1 %is_nan284, %1195, !dbg !1096
  %1196 = or i1 false, %is_snan285, !dbg !1096
  %1197 = bitcast float %1126 to i32, !dbg !1096
  %1198 = and i32 %1197, 2139095040, !dbg !1096
  %1199 = icmp eq i32 %1198, 2139095040, !dbg !1096
  %1200 = and i32 %1197, 8388607, !dbg !1096
  %1201 = icmp eq i32 %1200, 0, !dbg !1096
  %is_inf286 = and i1 %1199, %1201, !dbg !1096
  %1202 = and i1 false, %is_inf286, !dbg !1096
  %1203 = bitcast float %1126 to i32, !dbg !1096
  %1204 = and i32 %1203, 2147483647, !dbg !1096
  %is_zero287 = icmp eq i32 %1204, 0, !dbg !1096
  %1205 = and i1 false, %is_zero287, !dbg !1096
  %1206 = or i1 %1202, %1205, !dbg !1096
  %1207 = or i1 %1196, %1206, !dbg !1096
  br i1 %1207, label %1208, label %1210, !dbg !1096

1208:                                             ; preds = %1186
  %1209 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1210, !dbg !1096

1210:                                             ; preds = %1186, %1208
  %1211 = fmul float 2.000000e+00, %1126, !dbg !1096
  %1212 = bitcast float %1126 to i32, !dbg !1096
  %1213 = and i32 %1212, 2139095040, !dbg !1096
  %is_finite288 = icmp ne i32 %1213, 2139095040, !dbg !1096
  %1214 = and i1 true, %is_finite288, !dbg !1096
  %1215 = bitcast float %1211 to i32, !dbg !1096
  %1216 = and i32 %1215, 2139095040, !dbg !1096
  %1217 = icmp eq i32 %1216, 2139095040, !dbg !1096
  %1218 = and i32 %1215, 8388607, !dbg !1096
  %1219 = icmp eq i32 %1218, 0, !dbg !1096
  %is_inf289 = and i1 %1217, %1219, !dbg !1096
  %1220 = bitcast float %1211 to i32, !dbg !1096
  %1221 = and i32 %1220, 2147483647, !dbg !1096
  %is_maxfinite290 = icmp eq i32 %1221, 2139095039, !dbg !1096
  %1222 = bitcast float %1211 to i32, !dbg !1096
  %1223 = and i32 %1222, -2147483648, !dbg !1096
  %1224 = icmp eq i32 %1223, 0, !dbg !1096
  %1225 = icmp ne i32 %1223, 0, !dbg !1096
  %is_pos_inf291 = and i1 %is_inf289, %1224, !dbg !1096
  %is_neg_inf292 = and i1 %is_inf289, %1225, !dbg !1096
  %is_pos_max293 = and i1 %is_maxfinite290, %1224, !dbg !1096
  %is_neg_max294 = and i1 %is_maxfinite290, %1225, !dbg !1096
  %overflow_cond295 = and i1 %1214, %is_inf289, !dbg !1096
  br i1 %overflow_cond295, label %1226, label %1228, !dbg !1096

1226:                                             ; preds = %1210
  %1227 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1228, !dbg !1096

1228:                                             ; preds = %1210, %1226
  %1229 = bitcast float %1126 to i32, !dbg !1096
  %1230 = and i32 %1229, 2139095040, !dbg !1096
  %1231 = icmp eq i32 %1230, 0, !dbg !1096
  %1232 = and i32 %1229, 8388607, !dbg !1096
  %1233 = icmp ne i32 %1232, 0, !dbg !1096
  %is_subnormal296 = and i1 %1231, %1233, !dbg !1096
  %1234 = xor i1 %is_subnormal296, true, !dbg !1096
  %1235 = and i1 true, %1234, !dbg !1096
  %1236 = bitcast float %1211 to i32, !dbg !1096
  %1237 = and i32 %1236, 2139095040, !dbg !1096
  %1238 = icmp eq i32 %1237, 0, !dbg !1096
  %1239 = and i32 %1236, 8388607, !dbg !1096
  %1240 = icmp ne i32 %1239, 0, !dbg !1096
  %is_subnormal297 = and i1 %1238, %1240, !dbg !1096
  %1241 = bitcast float %1211 to i32, !dbg !1096
  %1242 = and i32 %1241, 2147483647, !dbg !1096
  %is_zero298 = icmp eq i32 %1242, 0, !dbg !1096
  %1243 = bitcast float %1126 to i32, !dbg !1096
  %1244 = and i32 %1243, 2147483647, !dbg !1096
  %is_zero299 = icmp eq i32 %1244, 0, !dbg !1096
  %1245 = xor i1 %is_zero299, true, !dbg !1096
  %1246 = and i1 true, %1245, !dbg !1096
  %1247 = and i1 %is_zero298, %1246, !dbg !1096
  %is_tiny300 = or i1 %is_subnormal297, %1247, !dbg !1096
  %underflow_cond301 = and i1 %1235, %is_tiny300, !dbg !1096
  br i1 %underflow_cond301, label %1248, label %1250, !dbg !1096

1248:                                             ; preds = %1228
  %1249 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1250, !dbg !1096

1250:                                             ; preds = %1228, %1248
  %1251 = bitcast float %1211 to i32, !dbg !1096
  %1252 = bitcast float %1211 to i32, !dbg !1096
  %1253 = and i32 %1252, 2139095040, !dbg !1096
  %1254 = icmp eq i32 %1253, 2139095040, !dbg !1096
  %1255 = and i32 %1252, 8388607, !dbg !1096
  %1256 = icmp ne i32 %1255, 0, !dbg !1096
  %is_nan302 = and i1 %1254, %1256, !dbg !1096
  %1257 = and i32 %1251, 4194304, !dbg !1096
  %1258 = icmp eq i32 %1257, 0, !dbg !1096
  %is_snan303 = and i1 %is_nan302, %1258, !dbg !1096
  %1259 = bitcast float %1187 to i32, !dbg !1096
  %1260 = bitcast float %1187 to i32, !dbg !1096
  %1261 = and i32 %1260, 2139095040, !dbg !1096
  %1262 = icmp eq i32 %1261, 2139095040, !dbg !1096
  %1263 = and i32 %1260, 8388607, !dbg !1096
  %1264 = icmp ne i32 %1263, 0, !dbg !1096
  %is_nan304 = and i1 %1262, %1264, !dbg !1096
  %1265 = and i32 %1259, 4194304, !dbg !1096
  %1266 = icmp eq i32 %1265, 0, !dbg !1096
  %is_snan305 = and i1 %is_nan304, %1266, !dbg !1096
  %1267 = or i1 %is_snan303, %is_snan305, !dbg !1096
  %1268 = bitcast float %1211 to i32, !dbg !1096
  %1269 = and i32 %1268, 2147483647, !dbg !1096
  %is_zero306 = icmp eq i32 %1269, 0, !dbg !1096
  %1270 = bitcast float %1187 to i32, !dbg !1096
  %1271 = and i32 %1270, 2139095040, !dbg !1096
  %1272 = icmp eq i32 %1271, 2139095040, !dbg !1096
  %1273 = and i32 %1270, 8388607, !dbg !1096
  %1274 = icmp eq i32 %1273, 0, !dbg !1096
  %is_inf307 = and i1 %1272, %1274, !dbg !1096
  %1275 = and i1 %is_zero306, %is_inf307, !dbg !1096
  %1276 = bitcast float %1211 to i32, !dbg !1096
  %1277 = and i32 %1276, 2139095040, !dbg !1096
  %1278 = icmp eq i32 %1277, 2139095040, !dbg !1096
  %1279 = and i32 %1276, 8388607, !dbg !1096
  %1280 = icmp eq i32 %1279, 0, !dbg !1096
  %is_inf308 = and i1 %1278, %1280, !dbg !1096
  %1281 = bitcast float %1187 to i32, !dbg !1096
  %1282 = and i32 %1281, 2147483647, !dbg !1096
  %is_zero309 = icmp eq i32 %1282, 0, !dbg !1096
  %1283 = and i1 %is_inf308, %is_zero309, !dbg !1096
  %1284 = or i1 %1275, %1283, !dbg !1096
  %1285 = or i1 %1267, %1284, !dbg !1096
  br i1 %1285, label %1286, label %1288, !dbg !1096

1286:                                             ; preds = %1250
  %1287 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1288, !dbg !1096

1288:                                             ; preds = %1250, %1286
  %1289 = fmul float %1211, %1187, !dbg !1096
  %1290 = bitcast float %1211 to i32, !dbg !1096
  %1291 = and i32 %1290, 2139095040, !dbg !1096
  %is_finite310 = icmp ne i32 %1291, 2139095040, !dbg !1096
  %1292 = and i1 true, %is_finite310, !dbg !1096
  %1293 = bitcast float %1187 to i32, !dbg !1096
  %1294 = and i32 %1293, 2139095040, !dbg !1096
  %is_finite311 = icmp ne i32 %1294, 2139095040, !dbg !1096
  %1295 = and i1 %1292, %is_finite311, !dbg !1096
  %1296 = bitcast float %1289 to i32, !dbg !1096
  %1297 = and i32 %1296, 2139095040, !dbg !1096
  %1298 = icmp eq i32 %1297, 2139095040, !dbg !1096
  %1299 = and i32 %1296, 8388607, !dbg !1096
  %1300 = icmp eq i32 %1299, 0, !dbg !1096
  %is_inf312 = and i1 %1298, %1300, !dbg !1096
  %1301 = bitcast float %1289 to i32, !dbg !1096
  %1302 = and i32 %1301, 2147483647, !dbg !1096
  %is_maxfinite313 = icmp eq i32 %1302, 2139095039, !dbg !1096
  %1303 = bitcast float %1289 to i32, !dbg !1096
  %1304 = and i32 %1303, -2147483648, !dbg !1096
  %1305 = icmp eq i32 %1304, 0, !dbg !1096
  %1306 = icmp ne i32 %1304, 0, !dbg !1096
  %is_pos_inf314 = and i1 %is_inf312, %1305, !dbg !1096
  %is_neg_inf315 = and i1 %is_inf312, %1306, !dbg !1096
  %is_pos_max316 = and i1 %is_maxfinite313, %1305, !dbg !1096
  %is_neg_max317 = and i1 %is_maxfinite313, %1306, !dbg !1096
  %overflow_cond318 = and i1 %1295, %is_inf312, !dbg !1096
  br i1 %overflow_cond318, label %1307, label %1309, !dbg !1096

1307:                                             ; preds = %1288
  %1308 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1309, !dbg !1096

1309:                                             ; preds = %1288, %1307
  %1310 = bitcast float %1211 to i32, !dbg !1096
  %1311 = and i32 %1310, 2139095040, !dbg !1096
  %1312 = icmp eq i32 %1311, 0, !dbg !1096
  %1313 = and i32 %1310, 8388607, !dbg !1096
  %1314 = icmp ne i32 %1313, 0, !dbg !1096
  %is_subnormal319 = and i1 %1312, %1314, !dbg !1096
  %1315 = xor i1 %is_subnormal319, true, !dbg !1096
  %1316 = and i1 true, %1315, !dbg !1096
  %1317 = bitcast float %1187 to i32, !dbg !1096
  %1318 = and i32 %1317, 2139095040, !dbg !1096
  %1319 = icmp eq i32 %1318, 0, !dbg !1096
  %1320 = and i32 %1317, 8388607, !dbg !1096
  %1321 = icmp ne i32 %1320, 0, !dbg !1096
  %is_subnormal320 = and i1 %1319, %1321, !dbg !1096
  %1322 = xor i1 %is_subnormal320, true, !dbg !1096
  %1323 = and i1 %1316, %1322, !dbg !1096
  %1324 = bitcast float %1289 to i32, !dbg !1096
  %1325 = and i32 %1324, 2139095040, !dbg !1096
  %1326 = icmp eq i32 %1325, 0, !dbg !1096
  %1327 = and i32 %1324, 8388607, !dbg !1096
  %1328 = icmp ne i32 %1327, 0, !dbg !1096
  %is_subnormal321 = and i1 %1326, %1328, !dbg !1096
  %1329 = bitcast float %1289 to i32, !dbg !1096
  %1330 = and i32 %1329, 2147483647, !dbg !1096
  %is_zero322 = icmp eq i32 %1330, 0, !dbg !1096
  %1331 = bitcast float %1211 to i32, !dbg !1096
  %1332 = and i32 %1331, 2147483647, !dbg !1096
  %is_zero323 = icmp eq i32 %1332, 0, !dbg !1096
  %1333 = xor i1 %is_zero323, true, !dbg !1096
  %1334 = bitcast float %1187 to i32, !dbg !1096
  %1335 = and i32 %1334, 2147483647, !dbg !1096
  %is_zero324 = icmp eq i32 %1335, 0, !dbg !1096
  %1336 = xor i1 %is_zero324, true, !dbg !1096
  %1337 = and i1 %1333, %1336, !dbg !1096
  %1338 = and i1 %is_zero322, %1337, !dbg !1096
  %is_tiny325 = or i1 %is_subnormal321, %1338, !dbg !1096
  %underflow_cond326 = and i1 %1323, %is_tiny325, !dbg !1096
  br i1 %underflow_cond326, label %1339, label %1341, !dbg !1096

1339:                                             ; preds = %1309
  %1340 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1341, !dbg !1096

1341:                                             ; preds = %1309, %1339
  %1342 = bitcast float %1289 to i32, !dbg !1096
  %1343 = bitcast float %1289 to i32, !dbg !1096
  %1344 = and i32 %1343, 2139095040, !dbg !1096
  %1345 = icmp eq i32 %1344, 2139095040, !dbg !1096
  %1346 = and i32 %1343, 8388607, !dbg !1096
  %1347 = icmp ne i32 %1346, 0, !dbg !1096
  %is_nan327 = and i1 %1345, %1347, !dbg !1096
  %1348 = and i32 %1342, 4194304, !dbg !1096
  %1349 = icmp eq i32 %1348, 0, !dbg !1096
  %is_snan328 = and i1 %is_nan327, %1349, !dbg !1096
  %1350 = bitcast float %1289 to i32, !dbg !1096
  %1351 = bitcast float %1289 to i32, !dbg !1096
  %1352 = and i32 %1351, 2139095040, !dbg !1096
  %1353 = icmp eq i32 %1352, 2139095040, !dbg !1096
  %1354 = and i32 %1351, 8388607, !dbg !1096
  %1355 = icmp ne i32 %1354, 0, !dbg !1096
  %is_nan329 = and i1 %1353, %1355, !dbg !1096
  %1356 = and i32 %1350, 4194304, !dbg !1096
  %1357 = icmp eq i32 %1356, 0, !dbg !1096
  %is_snan330 = and i1 %is_nan329, %1357, !dbg !1096
  %1358 = or i1 %is_snan328, %is_snan330, !dbg !1096
  %1359 = bitcast float %1289 to i32, !dbg !1096
  %1360 = and i32 %1359, 2147483647, !dbg !1096
  %is_zero331 = icmp eq i32 %1360, 0, !dbg !1096
  %1361 = bitcast float %1289 to i32, !dbg !1096
  %1362 = and i32 %1361, 2139095040, !dbg !1096
  %1363 = icmp eq i32 %1362, 2139095040, !dbg !1096
  %1364 = and i32 %1361, 8388607, !dbg !1096
  %1365 = icmp eq i32 %1364, 0, !dbg !1096
  %is_inf332 = and i1 %1363, %1365, !dbg !1096
  %1366 = and i1 %is_zero331, %is_inf332, !dbg !1096
  %1367 = bitcast float %1289 to i32, !dbg !1096
  %1368 = and i32 %1367, 2139095040, !dbg !1096
  %1369 = icmp eq i32 %1368, 2139095040, !dbg !1096
  %1370 = and i32 %1367, 8388607, !dbg !1096
  %1371 = icmp eq i32 %1370, 0, !dbg !1096
  %is_inf333 = and i1 %1369, %1371, !dbg !1096
  %1372 = bitcast float %1289 to i32, !dbg !1096
  %1373 = and i32 %1372, 2147483647, !dbg !1096
  %is_zero334 = icmp eq i32 %1373, 0, !dbg !1096
  %1374 = and i1 %is_inf333, %is_zero334, !dbg !1096
  %1375 = or i1 %1366, %1374, !dbg !1096
  %1376 = or i1 %1358, %1375, !dbg !1096
  br i1 %1376, label %1377, label %1379, !dbg !1096

1377:                                             ; preds = %1341
  %1378 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1379, !dbg !1096

1379:                                             ; preds = %1341, %1377
  %1380 = fmul float %1289, %1289, !dbg !1096
  %1381 = bitcast float %1289 to i32, !dbg !1096
  %1382 = and i32 %1381, 2139095040, !dbg !1096
  %is_finite335 = icmp ne i32 %1382, 2139095040, !dbg !1096
  %1383 = and i1 true, %is_finite335, !dbg !1096
  %1384 = bitcast float %1289 to i32, !dbg !1096
  %1385 = and i32 %1384, 2139095040, !dbg !1096
  %is_finite336 = icmp ne i32 %1385, 2139095040, !dbg !1096
  %1386 = and i1 %1383, %is_finite336, !dbg !1096
  %1387 = bitcast float %1380 to i32, !dbg !1096
  %1388 = and i32 %1387, 2139095040, !dbg !1096
  %1389 = icmp eq i32 %1388, 2139095040, !dbg !1096
  %1390 = and i32 %1387, 8388607, !dbg !1096
  %1391 = icmp eq i32 %1390, 0, !dbg !1096
  %is_inf337 = and i1 %1389, %1391, !dbg !1096
  %1392 = bitcast float %1380 to i32, !dbg !1096
  %1393 = and i32 %1392, 2147483647, !dbg !1096
  %is_maxfinite338 = icmp eq i32 %1393, 2139095039, !dbg !1096
  %1394 = bitcast float %1380 to i32, !dbg !1096
  %1395 = and i32 %1394, -2147483648, !dbg !1096
  %1396 = icmp eq i32 %1395, 0, !dbg !1096
  %1397 = icmp ne i32 %1395, 0, !dbg !1096
  %is_pos_inf339 = and i1 %is_inf337, %1396, !dbg !1096
  %is_neg_inf340 = and i1 %is_inf337, %1397, !dbg !1096
  %is_pos_max341 = and i1 %is_maxfinite338, %1396, !dbg !1096
  %is_neg_max342 = and i1 %is_maxfinite338, %1397, !dbg !1096
  %overflow_cond343 = and i1 %1386, %is_inf337, !dbg !1096
  br i1 %overflow_cond343, label %1398, label %1400, !dbg !1096

1398:                                             ; preds = %1379
  %1399 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1400, !dbg !1096

1400:                                             ; preds = %1379, %1398
  %1401 = bitcast float %1289 to i32, !dbg !1096
  %1402 = and i32 %1401, 2139095040, !dbg !1096
  %1403 = icmp eq i32 %1402, 0, !dbg !1096
  %1404 = and i32 %1401, 8388607, !dbg !1096
  %1405 = icmp ne i32 %1404, 0, !dbg !1096
  %is_subnormal344 = and i1 %1403, %1405, !dbg !1096
  %1406 = xor i1 %is_subnormal344, true, !dbg !1096
  %1407 = and i1 true, %1406, !dbg !1096
  %1408 = bitcast float %1289 to i32, !dbg !1096
  %1409 = and i32 %1408, 2139095040, !dbg !1096
  %1410 = icmp eq i32 %1409, 0, !dbg !1096
  %1411 = and i32 %1408, 8388607, !dbg !1096
  %1412 = icmp ne i32 %1411, 0, !dbg !1096
  %is_subnormal345 = and i1 %1410, %1412, !dbg !1096
  %1413 = xor i1 %is_subnormal345, true, !dbg !1096
  %1414 = and i1 %1407, %1413, !dbg !1096
  %1415 = bitcast float %1380 to i32, !dbg !1096
  %1416 = and i32 %1415, 2139095040, !dbg !1096
  %1417 = icmp eq i32 %1416, 0, !dbg !1096
  %1418 = and i32 %1415, 8388607, !dbg !1096
  %1419 = icmp ne i32 %1418, 0, !dbg !1096
  %is_subnormal346 = and i1 %1417, %1419, !dbg !1096
  %1420 = bitcast float %1380 to i32, !dbg !1096
  %1421 = and i32 %1420, 2147483647, !dbg !1096
  %is_zero347 = icmp eq i32 %1421, 0, !dbg !1096
  %1422 = bitcast float %1289 to i32, !dbg !1096
  %1423 = and i32 %1422, 2147483647, !dbg !1096
  %is_zero348 = icmp eq i32 %1423, 0, !dbg !1096
  %1424 = xor i1 %is_zero348, true, !dbg !1096
  %1425 = bitcast float %1289 to i32, !dbg !1096
  %1426 = and i32 %1425, 2147483647, !dbg !1096
  %is_zero349 = icmp eq i32 %1426, 0, !dbg !1096
  %1427 = xor i1 %is_zero349, true, !dbg !1096
  %1428 = and i1 %1424, %1427, !dbg !1096
  %1429 = and i1 %is_zero347, %1428, !dbg !1096
  %is_tiny350 = or i1 %is_subnormal346, %1429, !dbg !1096
  %underflow_cond351 = and i1 %1414, %is_tiny350, !dbg !1096
  br i1 %underflow_cond351, label %1430, label %1432, !dbg !1096

1430:                                             ; preds = %1400
  %1431 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1432, !dbg !1096

1432:                                             ; preds = %1400, %1430
  %1433 = bitcast float %1126 to i32, !dbg !1096
  %1434 = bitcast float %1126 to i32, !dbg !1096
  %1435 = and i32 %1434, 2139095040, !dbg !1096
  %1436 = icmp eq i32 %1435, 2139095040, !dbg !1096
  %1437 = and i32 %1434, 8388607, !dbg !1096
  %1438 = icmp ne i32 %1437, 0, !dbg !1096
  %is_nan352 = and i1 %1436, %1438, !dbg !1096
  %1439 = and i32 %1433, 4194304, !dbg !1096
  %1440 = icmp eq i32 %1439, 0, !dbg !1096
  %is_snan353 = and i1 %is_nan352, %1440, !dbg !1096
  %1441 = bitcast float %1289 to i32, !dbg !1096
  %1442 = bitcast float %1289 to i32, !dbg !1096
  %1443 = and i32 %1442, 2139095040, !dbg !1096
  %1444 = icmp eq i32 %1443, 2139095040, !dbg !1096
  %1445 = and i32 %1442, 8388607, !dbg !1096
  %1446 = icmp ne i32 %1445, 0, !dbg !1096
  %is_nan354 = and i1 %1444, %1446, !dbg !1096
  %1447 = and i32 %1441, 4194304, !dbg !1096
  %1448 = icmp eq i32 %1447, 0, !dbg !1096
  %is_snan355 = and i1 %is_nan354, %1448, !dbg !1096
  %1449 = or i1 %is_snan353, %is_snan355, !dbg !1096
  %1450 = bitcast float %1126 to i32, !dbg !1096
  %1451 = and i32 %1450, 2139095040, !dbg !1096
  %1452 = icmp eq i32 %1451, 2139095040, !dbg !1096
  %1453 = and i32 %1450, 8388607, !dbg !1096
  %1454 = icmp eq i32 %1453, 0, !dbg !1096
  %is_inf356 = and i1 %1452, %1454, !dbg !1096
  %1455 = bitcast float %1289 to i32, !dbg !1096
  %1456 = and i32 %1455, 2139095040, !dbg !1096
  %1457 = icmp eq i32 %1456, 2139095040, !dbg !1096
  %1458 = and i32 %1455, 8388607, !dbg !1096
  %1459 = icmp eq i32 %1458, 0, !dbg !1096
  %is_inf357 = and i1 %1457, %1459, !dbg !1096
  %1460 = and i1 %is_inf356, %is_inf357, !dbg !1096
  %1461 = bitcast float %1126 to i32, !dbg !1096
  %1462 = bitcast float %1289 to i32, !dbg !1096
  %1463 = and i32 %1461, -2147483648, !dbg !1096
  %1464 = and i32 %1462, -2147483648, !dbg !1096
  %1465 = icmp eq i32 %1463, %1464, !dbg !1096
  %1466 = and i1 %1460, %1465, !dbg !1096
  %1467 = or i1 %1449, %1466, !dbg !1096
  br i1 %1467, label %1468, label %1470, !dbg !1096

1468:                                             ; preds = %1432
  %1469 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1470, !dbg !1096

1470:                                             ; preds = %1432, %1468
  %1471 = fsub float %1126, %1289, !dbg !1096
  %1472 = bitcast float %1126 to i32, !dbg !1096
  %1473 = and i32 %1472, 2139095040, !dbg !1096
  %is_finite358 = icmp ne i32 %1473, 2139095040, !dbg !1096
  %1474 = and i1 true, %is_finite358, !dbg !1096
  %1475 = bitcast float %1289 to i32, !dbg !1096
  %1476 = and i32 %1475, 2139095040, !dbg !1096
  %is_finite359 = icmp ne i32 %1476, 2139095040, !dbg !1096
  %1477 = and i1 %1474, %is_finite359, !dbg !1096
  %1478 = bitcast float %1471 to i32, !dbg !1096
  %1479 = and i32 %1478, 2139095040, !dbg !1096
  %1480 = icmp eq i32 %1479, 2139095040, !dbg !1096
  %1481 = and i32 %1478, 8388607, !dbg !1096
  %1482 = icmp eq i32 %1481, 0, !dbg !1096
  %is_inf360 = and i1 %1480, %1482, !dbg !1096
  %1483 = bitcast float %1471 to i32, !dbg !1096
  %1484 = and i32 %1483, 2147483647, !dbg !1096
  %is_maxfinite361 = icmp eq i32 %1484, 2139095039, !dbg !1096
  %1485 = bitcast float %1471 to i32, !dbg !1096
  %1486 = and i32 %1485, -2147483648, !dbg !1096
  %1487 = icmp eq i32 %1486, 0, !dbg !1096
  %1488 = icmp ne i32 %1486, 0, !dbg !1096
  %is_pos_inf362 = and i1 %is_inf360, %1487, !dbg !1096
  %is_neg_inf363 = and i1 %is_inf360, %1488, !dbg !1096
  %is_pos_max364 = and i1 %is_maxfinite361, %1487, !dbg !1096
  %is_neg_max365 = and i1 %is_maxfinite361, %1488, !dbg !1096
  %overflow_cond366 = and i1 %1477, %is_inf360, !dbg !1096
  br i1 %overflow_cond366, label %1489, label %1491, !dbg !1096

1489:                                             ; preds = %1470
  %1490 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1491, !dbg !1096

1491:                                             ; preds = %1470, %1489
  %1492 = bitcast float %1471 to i32, !dbg !1096
  %1493 = bitcast float %1471 to i32, !dbg !1096
  %1494 = and i32 %1493, 2139095040, !dbg !1096
  %1495 = icmp eq i32 %1494, 2139095040, !dbg !1096
  %1496 = and i32 %1493, 8388607, !dbg !1096
  %1497 = icmp ne i32 %1496, 0, !dbg !1096
  %is_nan367 = and i1 %1495, %1497, !dbg !1096
  %1498 = and i32 %1492, 4194304, !dbg !1096
  %1499 = icmp eq i32 %1498, 0, !dbg !1096
  %is_snan368 = and i1 %is_nan367, %1499, !dbg !1096
  %1500 = or i1 false, %is_snan368, !dbg !1096
  %1501 = bitcast float %1471 to i32, !dbg !1096
  %1502 = and i32 %1501, 2139095040, !dbg !1096
  %1503 = icmp eq i32 %1502, 2139095040, !dbg !1096
  %1504 = and i32 %1501, 8388607, !dbg !1096
  %1505 = icmp eq i32 %1504, 0, !dbg !1096
  %is_inf369 = and i1 %1503, %1505, !dbg !1096
  %1506 = and i1 false, %is_inf369, !dbg !1096
  %1507 = bitcast float %1471 to i32, !dbg !1096
  %1508 = and i32 %1507, 2147483647, !dbg !1096
  %is_zero370 = icmp eq i32 %1508, 0, !dbg !1096
  %1509 = and i1 false, %is_zero370, !dbg !1096
  %1510 = or i1 %1506, %1509, !dbg !1096
  %1511 = or i1 %1500, %1510, !dbg !1096
  br i1 %1511, label %1512, label %1514, !dbg !1096

1512:                                             ; preds = %1491
  %1513 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1514, !dbg !1096

1514:                                             ; preds = %1491, %1512
  %1515 = fmul float 2.000000e+00, %1471, !dbg !1096
  %1516 = bitcast float %1471 to i32, !dbg !1096
  %1517 = and i32 %1516, 2139095040, !dbg !1096
  %is_finite371 = icmp ne i32 %1517, 2139095040, !dbg !1096
  %1518 = and i1 true, %is_finite371, !dbg !1096
  %1519 = bitcast float %1515 to i32, !dbg !1096
  %1520 = and i32 %1519, 2139095040, !dbg !1096
  %1521 = icmp eq i32 %1520, 2139095040, !dbg !1096
  %1522 = and i32 %1519, 8388607, !dbg !1096
  %1523 = icmp eq i32 %1522, 0, !dbg !1096
  %is_inf372 = and i1 %1521, %1523, !dbg !1096
  %1524 = bitcast float %1515 to i32, !dbg !1096
  %1525 = and i32 %1524, 2147483647, !dbg !1096
  %is_maxfinite373 = icmp eq i32 %1525, 2139095039, !dbg !1096
  %1526 = bitcast float %1515 to i32, !dbg !1096
  %1527 = and i32 %1526, -2147483648, !dbg !1096
  %1528 = icmp eq i32 %1527, 0, !dbg !1096
  %1529 = icmp ne i32 %1527, 0, !dbg !1096
  %is_pos_inf374 = and i1 %is_inf372, %1528, !dbg !1096
  %is_neg_inf375 = and i1 %is_inf372, %1529, !dbg !1096
  %is_pos_max376 = and i1 %is_maxfinite373, %1528, !dbg !1096
  %is_neg_max377 = and i1 %is_maxfinite373, %1529, !dbg !1096
  %overflow_cond378 = and i1 %1518, %is_inf372, !dbg !1096
  br i1 %overflow_cond378, label %1530, label %1532, !dbg !1096

1530:                                             ; preds = %1514
  %1531 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1532, !dbg !1096

1532:                                             ; preds = %1514, %1530
  %1533 = bitcast float %1471 to i32, !dbg !1096
  %1534 = and i32 %1533, 2139095040, !dbg !1096
  %1535 = icmp eq i32 %1534, 0, !dbg !1096
  %1536 = and i32 %1533, 8388607, !dbg !1096
  %1537 = icmp ne i32 %1536, 0, !dbg !1096
  %is_subnormal379 = and i1 %1535, %1537, !dbg !1096
  %1538 = xor i1 %is_subnormal379, true, !dbg !1096
  %1539 = and i1 true, %1538, !dbg !1096
  %1540 = bitcast float %1515 to i32, !dbg !1096
  %1541 = and i32 %1540, 2139095040, !dbg !1096
  %1542 = icmp eq i32 %1541, 0, !dbg !1096
  %1543 = and i32 %1540, 8388607, !dbg !1096
  %1544 = icmp ne i32 %1543, 0, !dbg !1096
  %is_subnormal380 = and i1 %1542, %1544, !dbg !1096
  %1545 = bitcast float %1515 to i32, !dbg !1096
  %1546 = and i32 %1545, 2147483647, !dbg !1096
  %is_zero381 = icmp eq i32 %1546, 0, !dbg !1096
  %1547 = bitcast float %1471 to i32, !dbg !1096
  %1548 = and i32 %1547, 2147483647, !dbg !1096
  %is_zero382 = icmp eq i32 %1548, 0, !dbg !1096
  %1549 = xor i1 %is_zero382, true, !dbg !1096
  %1550 = and i1 true, %1549, !dbg !1096
  %1551 = and i1 %is_zero381, %1550, !dbg !1096
  %is_tiny383 = or i1 %is_subnormal380, %1551, !dbg !1096
  %underflow_cond384 = and i1 %1539, %is_tiny383, !dbg !1096
  br i1 %underflow_cond384, label %1552, label %1554, !dbg !1096

1552:                                             ; preds = %1532
  %1553 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1554, !dbg !1096

1554:                                             ; preds = %1532, %1552
  %1555 = bitcast float %1289 to i32, !dbg !1096
  %1556 = bitcast float %1289 to i32, !dbg !1096
  %1557 = and i32 %1556, 2139095040, !dbg !1096
  %1558 = icmp eq i32 %1557, 2139095040, !dbg !1096
  %1559 = and i32 %1556, 8388607, !dbg !1096
  %1560 = icmp ne i32 %1559, 0, !dbg !1096
  %is_nan385 = and i1 %1558, %1560, !dbg !1096
  %1561 = and i32 %1555, 4194304, !dbg !1096
  %1562 = icmp eq i32 %1561, 0, !dbg !1096
  %is_snan386 = and i1 %is_nan385, %1562, !dbg !1096
  %1563 = or i1 false, %is_snan386, !dbg !1096
  %1564 = bitcast float %1289 to i32, !dbg !1096
  %1565 = and i32 %1564, 2139095040, !dbg !1096
  %1566 = icmp eq i32 %1565, 2139095040, !dbg !1096
  %1567 = and i32 %1564, 8388607, !dbg !1096
  %1568 = icmp eq i32 %1567, 0, !dbg !1096
  %is_inf387 = and i1 %1566, %1568, !dbg !1096
  %1569 = and i1 false, %is_inf387, !dbg !1096
  %1570 = bitcast float %1289 to i32, !dbg !1096
  %1571 = and i32 %1570, -2147483648, !dbg !1096
  %1572 = icmp eq i32 -2147483648, %1571, !dbg !1096
  %1573 = and i1 %1569, %1572, !dbg !1096
  %1574 = or i1 %1563, %1573, !dbg !1096
  br i1 %1574, label %1575, label %1577, !dbg !1096

1575:                                             ; preds = %1554
  %1576 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1577, !dbg !1096

1577:                                             ; preds = %1554, %1575
  %1578 = fsub float -0.000000e+00, %1289, !dbg !1096
  %1579 = bitcast float %1289 to i32, !dbg !1096
  %1580 = and i32 %1579, 2139095040, !dbg !1096
  %is_finite388 = icmp ne i32 %1580, 2139095040, !dbg !1096
  %1581 = and i1 true, %is_finite388, !dbg !1096
  %1582 = bitcast float %1578 to i32, !dbg !1096
  %1583 = and i32 %1582, 2139095040, !dbg !1096
  %1584 = icmp eq i32 %1583, 2139095040, !dbg !1096
  %1585 = and i32 %1582, 8388607, !dbg !1096
  %1586 = icmp eq i32 %1585, 0, !dbg !1096
  %is_inf389 = and i1 %1584, %1586, !dbg !1096
  %1587 = bitcast float %1578 to i32, !dbg !1096
  %1588 = and i32 %1587, 2147483647, !dbg !1096
  %is_maxfinite390 = icmp eq i32 %1588, 2139095039, !dbg !1096
  %1589 = bitcast float %1578 to i32, !dbg !1096
  %1590 = and i32 %1589, -2147483648, !dbg !1096
  %1591 = icmp eq i32 %1590, 0, !dbg !1096
  %1592 = icmp ne i32 %1590, 0, !dbg !1096
  %is_pos_inf391 = and i1 %is_inf389, %1591, !dbg !1096
  %is_neg_inf392 = and i1 %is_inf389, %1592, !dbg !1096
  %is_pos_max393 = and i1 %is_maxfinite390, %1591, !dbg !1096
  %is_neg_max394 = and i1 %is_maxfinite390, %1592, !dbg !1096
  %overflow_cond395 = and i1 %1581, %is_inf389, !dbg !1096
  br i1 %overflow_cond395, label %1593, label %1595, !dbg !1096

1593:                                             ; preds = %1577
  %1594 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1595, !dbg !1096

1595:                                             ; preds = %1577, %1593
  %1596 = bitcast float %1578 to i32, !dbg !1096
  %1597 = bitcast float %1578 to i32, !dbg !1096
  %1598 = and i32 %1597, 2139095040, !dbg !1096
  %1599 = icmp eq i32 %1598, 2139095040, !dbg !1096
  %1600 = and i32 %1597, 8388607, !dbg !1096
  %1601 = icmp ne i32 %1600, 0, !dbg !1096
  %is_nan396 = and i1 %1599, %1601, !dbg !1096
  %1602 = and i32 %1596, 4194304, !dbg !1096
  %1603 = icmp eq i32 %1602, 0, !dbg !1096
  %is_snan397 = and i1 %is_nan396, %1603, !dbg !1096
  %1604 = bitcast float %1126 to i32, !dbg !1096
  %1605 = bitcast float %1126 to i32, !dbg !1096
  %1606 = and i32 %1605, 2139095040, !dbg !1096
  %1607 = icmp eq i32 %1606, 2139095040, !dbg !1096
  %1608 = and i32 %1605, 8388607, !dbg !1096
  %1609 = icmp ne i32 %1608, 0, !dbg !1096
  %is_nan398 = and i1 %1607, %1609, !dbg !1096
  %1610 = and i32 %1604, 4194304, !dbg !1096
  %1611 = icmp eq i32 %1610, 0, !dbg !1096
  %is_snan399 = and i1 %is_nan398, %1611, !dbg !1096
  %1612 = or i1 %is_snan397, %is_snan399, !dbg !1096
  %1613 = bitcast float %1515 to i32, !dbg !1096
  %1614 = bitcast float %1515 to i32, !dbg !1096
  %1615 = and i32 %1614, 2139095040, !dbg !1096
  %1616 = icmp eq i32 %1615, 2139095040, !dbg !1096
  %1617 = and i32 %1614, 8388607, !dbg !1096
  %1618 = icmp ne i32 %1617, 0, !dbg !1096
  %is_nan400 = and i1 %1616, %1618, !dbg !1096
  %1619 = and i32 %1613, 4194304, !dbg !1096
  %1620 = icmp eq i32 %1619, 0, !dbg !1096
  %is_snan401 = and i1 %is_nan400, %1620, !dbg !1096
  %1621 = or i1 %1612, %is_snan401, !dbg !1096
  %1622 = bitcast float %1578 to i32, !dbg !1096
  %1623 = and i32 %1622, 2147483647, !dbg !1096
  %is_zero402 = icmp eq i32 %1623, 0, !dbg !1096
  %1624 = bitcast float %1126 to i32, !dbg !1096
  %1625 = and i32 %1624, 2139095040, !dbg !1096
  %1626 = icmp eq i32 %1625, 2139095040, !dbg !1096
  %1627 = and i32 %1624, 8388607, !dbg !1096
  %1628 = icmp eq i32 %1627, 0, !dbg !1096
  %is_inf403 = and i1 %1626, %1628, !dbg !1096
  %1629 = and i1 %is_zero402, %is_inf403, !dbg !1096
  %1630 = bitcast float %1578 to i32, !dbg !1096
  %1631 = and i32 %1630, 2139095040, !dbg !1096
  %1632 = icmp eq i32 %1631, 2139095040, !dbg !1096
  %1633 = and i32 %1630, 8388607, !dbg !1096
  %1634 = icmp eq i32 %1633, 0, !dbg !1096
  %is_inf404 = and i1 %1632, %1634, !dbg !1096
  %1635 = bitcast float %1126 to i32, !dbg !1096
  %1636 = and i32 %1635, 2147483647, !dbg !1096
  %is_zero405 = icmp eq i32 %1636, 0, !dbg !1096
  %1637 = and i1 %is_inf404, %is_zero405, !dbg !1096
  %1638 = or i1 %1629, %1637, !dbg !1096
  %1639 = or i1 %1621, %1638, !dbg !1096
  br i1 %1639, label %1640, label %1642, !dbg !1096

1640:                                             ; preds = %1595
  %1641 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1642, !dbg !1096

1642:                                             ; preds = %1595, %1640
  %1643 = call float @llvm.nvvm.fma.rn.f(float %1578, float %1126, float %1515) #5, !dbg !1096
  %1644 = bitcast float %1578 to i32, !dbg !1096
  %1645 = and i32 %1644, 2139095040, !dbg !1096
  %is_finite406 = icmp ne i32 %1645, 2139095040, !dbg !1096
  %1646 = and i1 true, %is_finite406, !dbg !1096
  %1647 = bitcast float %1126 to i32, !dbg !1096
  %1648 = and i32 %1647, 2139095040, !dbg !1096
  %is_finite407 = icmp ne i32 %1648, 2139095040, !dbg !1096
  %1649 = and i1 %1646, %is_finite407, !dbg !1096
  %1650 = bitcast float %1643 to i32, !dbg !1096
  %1651 = and i32 %1650, 2139095040, !dbg !1096
  %1652 = icmp eq i32 %1651, 2139095040, !dbg !1096
  %1653 = and i32 %1650, 8388607, !dbg !1096
  %1654 = icmp eq i32 %1653, 0, !dbg !1096
  %is_inf408 = and i1 %1652, %1654, !dbg !1096
  %1655 = bitcast float %1643 to i32, !dbg !1096
  %1656 = and i32 %1655, 2147483647, !dbg !1096
  %is_maxfinite409 = icmp eq i32 %1656, 2139095039, !dbg !1096
  %1657 = bitcast float %1643 to i32, !dbg !1096
  %1658 = and i32 %1657, -2147483648, !dbg !1096
  %1659 = icmp eq i32 %1658, 0, !dbg !1096
  %1660 = icmp ne i32 %1658, 0, !dbg !1096
  %is_pos_inf410 = and i1 %is_inf408, %1659, !dbg !1096
  %is_neg_inf411 = and i1 %is_inf408, %1660, !dbg !1096
  %is_pos_max412 = and i1 %is_maxfinite409, %1659, !dbg !1096
  %is_neg_max413 = and i1 %is_maxfinite409, %1660, !dbg !1096
  %overflow_cond414 = and i1 %1649, %is_inf408, !dbg !1096
  br i1 %overflow_cond414, label %1661, label %1663, !dbg !1096

1661:                                             ; preds = %1642
  %1662 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1663, !dbg !1096

1663:                                             ; preds = %1642, %1661
  %1664 = bitcast float %1578 to i32, !dbg !1096
  %1665 = and i32 %1664, 2139095040, !dbg !1096
  %1666 = icmp eq i32 %1665, 0, !dbg !1096
  %1667 = and i32 %1664, 8388607, !dbg !1096
  %1668 = icmp ne i32 %1667, 0, !dbg !1096
  %is_subnormal415 = and i1 %1666, %1668, !dbg !1096
  %1669 = xor i1 %is_subnormal415, true, !dbg !1096
  %1670 = and i1 true, %1669, !dbg !1096
  %1671 = bitcast float %1126 to i32, !dbg !1096
  %1672 = and i32 %1671, 2139095040, !dbg !1096
  %1673 = icmp eq i32 %1672, 0, !dbg !1096
  %1674 = and i32 %1671, 8388607, !dbg !1096
  %1675 = icmp ne i32 %1674, 0, !dbg !1096
  %is_subnormal416 = and i1 %1673, %1675, !dbg !1096
  %1676 = xor i1 %is_subnormal416, true, !dbg !1096
  %1677 = and i1 %1670, %1676, !dbg !1096
  %1678 = bitcast float %1515 to i32, !dbg !1096
  %1679 = and i32 %1678, 2139095040, !dbg !1096
  %1680 = icmp eq i32 %1679, 0, !dbg !1096
  %1681 = and i32 %1678, 8388607, !dbg !1096
  %1682 = icmp ne i32 %1681, 0, !dbg !1096
  %is_subnormal417 = and i1 %1680, %1682, !dbg !1096
  %1683 = xor i1 %is_subnormal417, true, !dbg !1096
  %1684 = and i1 %1677, %1683, !dbg !1096
  %1685 = bitcast float %1643 to i32, !dbg !1096
  %1686 = and i32 %1685, 2139095040, !dbg !1096
  %1687 = icmp eq i32 %1686, 0, !dbg !1096
  %1688 = and i32 %1685, 8388607, !dbg !1096
  %1689 = icmp ne i32 %1688, 0, !dbg !1096
  %is_subnormal418 = and i1 %1687, %1689, !dbg !1096
  %is_tiny419 = or i1 %is_subnormal418, false, !dbg !1096
  %underflow_cond420 = and i1 %1684, %is_tiny419, !dbg !1096
  br i1 %underflow_cond420, label %1690, label %1692, !dbg !1096

1690:                                             ; preds = %1663
  %1691 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1692, !dbg !1096

1692:                                             ; preds = %1663, %1690
  %1693 = bitcast float %1187 to i32, !dbg !1096
  %1694 = bitcast float %1187 to i32, !dbg !1096
  %1695 = and i32 %1694, 2139095040, !dbg !1096
  %1696 = icmp eq i32 %1695, 2139095040, !dbg !1096
  %1697 = and i32 %1694, 8388607, !dbg !1096
  %1698 = icmp ne i32 %1697, 0, !dbg !1096
  %is_nan421 = and i1 %1696, %1698, !dbg !1096
  %1699 = and i32 %1693, 4194304, !dbg !1096
  %1700 = icmp eq i32 %1699, 0, !dbg !1096
  %is_snan422 = and i1 %is_nan421, %1700, !dbg !1096
  %1701 = bitcast float %1643 to i32, !dbg !1096
  %1702 = bitcast float %1643 to i32, !dbg !1096
  %1703 = and i32 %1702, 2139095040, !dbg !1096
  %1704 = icmp eq i32 %1703, 2139095040, !dbg !1096
  %1705 = and i32 %1702, 8388607, !dbg !1096
  %1706 = icmp ne i32 %1705, 0, !dbg !1096
  %is_nan423 = and i1 %1704, %1706, !dbg !1096
  %1707 = and i32 %1701, 4194304, !dbg !1096
  %1708 = icmp eq i32 %1707, 0, !dbg !1096
  %is_snan424 = and i1 %is_nan423, %1708, !dbg !1096
  %1709 = or i1 %is_snan422, %is_snan424, !dbg !1096
  %1710 = bitcast float %1187 to i32, !dbg !1096
  %1711 = and i32 %1710, 2147483647, !dbg !1096
  %is_zero425 = icmp eq i32 %1711, 0, !dbg !1096
  %1712 = bitcast float %1643 to i32, !dbg !1096
  %1713 = and i32 %1712, 2139095040, !dbg !1096
  %1714 = icmp eq i32 %1713, 2139095040, !dbg !1096
  %1715 = and i32 %1712, 8388607, !dbg !1096
  %1716 = icmp eq i32 %1715, 0, !dbg !1096
  %is_inf426 = and i1 %1714, %1716, !dbg !1096
  %1717 = and i1 %is_zero425, %is_inf426, !dbg !1096
  %1718 = bitcast float %1187 to i32, !dbg !1096
  %1719 = and i32 %1718, 2139095040, !dbg !1096
  %1720 = icmp eq i32 %1719, 2139095040, !dbg !1096
  %1721 = and i32 %1718, 8388607, !dbg !1096
  %1722 = icmp eq i32 %1721, 0, !dbg !1096
  %is_inf427 = and i1 %1720, %1722, !dbg !1096
  %1723 = bitcast float %1643 to i32, !dbg !1096
  %1724 = and i32 %1723, 2147483647, !dbg !1096
  %is_zero428 = icmp eq i32 %1724, 0, !dbg !1096
  %1725 = and i1 %is_inf427, %is_zero428, !dbg !1096
  %1726 = or i1 %1717, %1725, !dbg !1096
  %1727 = or i1 %1709, %1726, !dbg !1096
  br i1 %1727, label %1728, label %1730, !dbg !1096

1728:                                             ; preds = %1692
  %1729 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1730, !dbg !1096

1730:                                             ; preds = %1692, %1728
  %1731 = call float @llvm.nvvm.mul.rn.f(float %1187, float %1643) #5, !dbg !1096
  %1732 = bitcast float %1187 to i32, !dbg !1096
  %1733 = and i32 %1732, 2139095040, !dbg !1096
  %is_finite429 = icmp ne i32 %1733, 2139095040, !dbg !1096
  %1734 = and i1 true, %is_finite429, !dbg !1096
  %1735 = bitcast float %1643 to i32, !dbg !1096
  %1736 = and i32 %1735, 2139095040, !dbg !1096
  %is_finite430 = icmp ne i32 %1736, 2139095040, !dbg !1096
  %1737 = and i1 %1734, %is_finite430, !dbg !1096
  %1738 = bitcast float %1731 to i32, !dbg !1096
  %1739 = and i32 %1738, 2139095040, !dbg !1096
  %1740 = icmp eq i32 %1739, 2139095040, !dbg !1096
  %1741 = and i32 %1738, 8388607, !dbg !1096
  %1742 = icmp eq i32 %1741, 0, !dbg !1096
  %is_inf431 = and i1 %1740, %1742, !dbg !1096
  %1743 = bitcast float %1731 to i32, !dbg !1096
  %1744 = and i32 %1743, 2147483647, !dbg !1096
  %is_maxfinite432 = icmp eq i32 %1744, 2139095039, !dbg !1096
  %1745 = bitcast float %1731 to i32, !dbg !1096
  %1746 = and i32 %1745, -2147483648, !dbg !1096
  %1747 = icmp eq i32 %1746, 0, !dbg !1096
  %1748 = icmp ne i32 %1746, 0, !dbg !1096
  %is_pos_inf433 = and i1 %is_inf431, %1747, !dbg !1096
  %is_neg_inf434 = and i1 %is_inf431, %1748, !dbg !1096
  %is_pos_max435 = and i1 %is_maxfinite432, %1747, !dbg !1096
  %is_neg_max436 = and i1 %is_maxfinite432, %1748, !dbg !1096
  %overflow_cond437 = and i1 %1737, %is_inf431, !dbg !1096
  br i1 %overflow_cond437, label %1749, label %1751, !dbg !1096

1749:                                             ; preds = %1730
  %1750 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1751, !dbg !1096

1751:                                             ; preds = %1730, %1749
  %1752 = bitcast float %1187 to i32, !dbg !1096
  %1753 = and i32 %1752, 2139095040, !dbg !1096
  %1754 = icmp eq i32 %1753, 0, !dbg !1096
  %1755 = and i32 %1752, 8388607, !dbg !1096
  %1756 = icmp ne i32 %1755, 0, !dbg !1096
  %is_subnormal438 = and i1 %1754, %1756, !dbg !1096
  %1757 = xor i1 %is_subnormal438, true, !dbg !1096
  %1758 = and i1 true, %1757, !dbg !1096
  %1759 = bitcast float %1643 to i32, !dbg !1096
  %1760 = and i32 %1759, 2139095040, !dbg !1096
  %1761 = icmp eq i32 %1760, 0, !dbg !1096
  %1762 = and i32 %1759, 8388607, !dbg !1096
  %1763 = icmp ne i32 %1762, 0, !dbg !1096
  %is_subnormal439 = and i1 %1761, %1763, !dbg !1096
  %1764 = xor i1 %is_subnormal439, true, !dbg !1096
  %1765 = and i1 %1758, %1764, !dbg !1096
  %1766 = bitcast float %1731 to i32, !dbg !1096
  %1767 = and i32 %1766, 2139095040, !dbg !1096
  %1768 = icmp eq i32 %1767, 0, !dbg !1096
  %1769 = and i32 %1766, 8388607, !dbg !1096
  %1770 = icmp ne i32 %1769, 0, !dbg !1096
  %is_subnormal440 = and i1 %1768, %1770, !dbg !1096
  %1771 = bitcast float %1731 to i32, !dbg !1096
  %1772 = and i32 %1771, 2147483647, !dbg !1096
  %is_zero441 = icmp eq i32 %1772, 0, !dbg !1096
  %1773 = bitcast float %1187 to i32, !dbg !1096
  %1774 = and i32 %1773, 2147483647, !dbg !1096
  %is_zero442 = icmp eq i32 %1774, 0, !dbg !1096
  %1775 = xor i1 %is_zero442, true, !dbg !1096
  %1776 = bitcast float %1643 to i32, !dbg !1096
  %1777 = and i32 %1776, 2147483647, !dbg !1096
  %is_zero443 = icmp eq i32 %1777, 0, !dbg !1096
  %1778 = xor i1 %is_zero443, true, !dbg !1096
  %1779 = and i1 %1775, %1778, !dbg !1096
  %1780 = and i1 %is_zero441, %1779, !dbg !1096
  %is_tiny444 = or i1 %is_subnormal440, %1780, !dbg !1096
  %underflow_cond445 = and i1 %1765, %is_tiny444, !dbg !1096
  br i1 %underflow_cond445, label %1781, label %1783, !dbg !1096

1781:                                             ; preds = %1751
  %1782 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1783, !dbg !1096

1783:                                             ; preds = %1751, %1781
  %1784 = bitcast float %1380 to i32, !dbg !1096
  %1785 = bitcast float %1380 to i32, !dbg !1096
  %1786 = and i32 %1785, 2139095040, !dbg !1096
  %1787 = icmp eq i32 %1786, 2139095040, !dbg !1096
  %1788 = and i32 %1785, 8388607, !dbg !1096
  %1789 = icmp ne i32 %1788, 0, !dbg !1096
  %is_nan446 = and i1 %1787, %1789, !dbg !1096
  %1790 = and i32 %1784, 4194304, !dbg !1096
  %1791 = icmp eq i32 %1790, 0, !dbg !1096
  %is_snan447 = and i1 %is_nan446, %1791, !dbg !1096
  %1792 = or i1 false, %is_snan447, !dbg !1096
  %1793 = or i1 %1792, false, !dbg !1096
  %1794 = bitcast float %1380 to i32, !dbg !1096
  %1795 = and i32 %1794, 2139095040, !dbg !1096
  %1796 = icmp eq i32 %1795, 2139095040, !dbg !1096
  %1797 = and i32 %1794, 8388607, !dbg !1096
  %1798 = icmp eq i32 %1797, 0, !dbg !1096
  %is_inf448 = and i1 %1796, %1798, !dbg !1096
  %1799 = and i1 false, %is_inf448, !dbg !1096
  %1800 = bitcast float %1380 to i32, !dbg !1096
  %1801 = and i32 %1800, 2147483647, !dbg !1096
  %is_zero449 = icmp eq i32 %1801, 0, !dbg !1096
  %1802 = and i1 false, %is_zero449, !dbg !1096
  %1803 = or i1 %1799, %1802, !dbg !1096
  %1804 = or i1 %1793, %1803, !dbg !1096
  br i1 %1804, label %1805, label %1807, !dbg !1096

1805:                                             ; preds = %1783
  %1806 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1807, !dbg !1096

1807:                                             ; preds = %1783, %1805
  %1808 = call float @llvm.nvvm.fma.rn.f(float 0x3F45865C80000000, float %1380, float 0x3F6A5CFB60000000) #5, !dbg !1096
  %1809 = bitcast float %1380 to i32, !dbg !1096
  %1810 = and i32 %1809, 2139095040, !dbg !1096
  %is_finite450 = icmp ne i32 %1810, 2139095040, !dbg !1096
  %1811 = and i1 true, %is_finite450, !dbg !1096
  %1812 = bitcast float %1808 to i32, !dbg !1096
  %1813 = and i32 %1812, 2139095040, !dbg !1096
  %1814 = icmp eq i32 %1813, 2139095040, !dbg !1096
  %1815 = and i32 %1812, 8388607, !dbg !1096
  %1816 = icmp eq i32 %1815, 0, !dbg !1096
  %is_inf451 = and i1 %1814, %1816, !dbg !1096
  %1817 = bitcast float %1808 to i32, !dbg !1096
  %1818 = and i32 %1817, 2147483647, !dbg !1096
  %is_maxfinite452 = icmp eq i32 %1818, 2139095039, !dbg !1096
  %1819 = bitcast float %1808 to i32, !dbg !1096
  %1820 = and i32 %1819, -2147483648, !dbg !1096
  %1821 = icmp eq i32 %1820, 0, !dbg !1096
  %1822 = icmp ne i32 %1820, 0, !dbg !1096
  %is_pos_inf453 = and i1 %is_inf451, %1821, !dbg !1096
  %is_neg_inf454 = and i1 %is_inf451, %1822, !dbg !1096
  %is_pos_max455 = and i1 %is_maxfinite452, %1821, !dbg !1096
  %is_neg_max456 = and i1 %is_maxfinite452, %1822, !dbg !1096
  %overflow_cond457 = and i1 %1811, %is_inf451, !dbg !1096
  br i1 %overflow_cond457, label %1823, label %1825, !dbg !1096

1823:                                             ; preds = %1807
  %1824 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1825, !dbg !1096

1825:                                             ; preds = %1807, %1823
  %1826 = bitcast float %1380 to i32, !dbg !1096
  %1827 = and i32 %1826, 2139095040, !dbg !1096
  %1828 = icmp eq i32 %1827, 0, !dbg !1096
  %1829 = and i32 %1826, 8388607, !dbg !1096
  %1830 = icmp ne i32 %1829, 0, !dbg !1096
  %is_subnormal458 = and i1 %1828, %1830, !dbg !1096
  %1831 = xor i1 %is_subnormal458, true, !dbg !1096
  %1832 = and i1 true, %1831, !dbg !1096
  %1833 = and i1 %1832, true, !dbg !1096
  %1834 = bitcast float %1808 to i32, !dbg !1096
  %1835 = and i32 %1834, 2139095040, !dbg !1096
  %1836 = icmp eq i32 %1835, 0, !dbg !1096
  %1837 = and i32 %1834, 8388607, !dbg !1096
  %1838 = icmp ne i32 %1837, 0, !dbg !1096
  %is_subnormal459 = and i1 %1836, %1838, !dbg !1096
  %is_tiny460 = or i1 %is_subnormal459, false, !dbg !1096
  %underflow_cond461 = and i1 %1833, %is_tiny460, !dbg !1096
  br i1 %underflow_cond461, label %1839, label %1841, !dbg !1096

1839:                                             ; preds = %1825
  %1840 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1841, !dbg !1096

1841:                                             ; preds = %1825, %1839
  %1842 = bitcast float %1808 to i32, !dbg !1096
  %1843 = bitcast float %1808 to i32, !dbg !1096
  %1844 = and i32 %1843, 2139095040, !dbg !1096
  %1845 = icmp eq i32 %1844, 2139095040, !dbg !1096
  %1846 = and i32 %1843, 8388607, !dbg !1096
  %1847 = icmp ne i32 %1846, 0, !dbg !1096
  %is_nan462 = and i1 %1845, %1847, !dbg !1096
  %1848 = and i32 %1842, 4194304, !dbg !1096
  %1849 = icmp eq i32 %1848, 0, !dbg !1096
  %is_snan463 = and i1 %is_nan462, %1849, !dbg !1096
  %1850 = bitcast float %1380 to i32, !dbg !1096
  %1851 = bitcast float %1380 to i32, !dbg !1096
  %1852 = and i32 %1851, 2139095040, !dbg !1096
  %1853 = icmp eq i32 %1852, 2139095040, !dbg !1096
  %1854 = and i32 %1851, 8388607, !dbg !1096
  %1855 = icmp ne i32 %1854, 0, !dbg !1096
  %is_nan464 = and i1 %1853, %1855, !dbg !1096
  %1856 = and i32 %1850, 4194304, !dbg !1096
  %1857 = icmp eq i32 %1856, 0, !dbg !1096
  %is_snan465 = and i1 %is_nan464, %1857, !dbg !1096
  %1858 = or i1 %is_snan463, %is_snan465, !dbg !1096
  %1859 = or i1 %1858, false, !dbg !1096
  %1860 = bitcast float %1808 to i32, !dbg !1096
  %1861 = and i32 %1860, 2147483647, !dbg !1096
  %is_zero466 = icmp eq i32 %1861, 0, !dbg !1096
  %1862 = bitcast float %1380 to i32, !dbg !1096
  %1863 = and i32 %1862, 2139095040, !dbg !1096
  %1864 = icmp eq i32 %1863, 2139095040, !dbg !1096
  %1865 = and i32 %1862, 8388607, !dbg !1096
  %1866 = icmp eq i32 %1865, 0, !dbg !1096
  %is_inf467 = and i1 %1864, %1866, !dbg !1096
  %1867 = and i1 %is_zero466, %is_inf467, !dbg !1096
  %1868 = bitcast float %1808 to i32, !dbg !1096
  %1869 = and i32 %1868, 2139095040, !dbg !1096
  %1870 = icmp eq i32 %1869, 2139095040, !dbg !1096
  %1871 = and i32 %1868, 8388607, !dbg !1096
  %1872 = icmp eq i32 %1871, 0, !dbg !1096
  %is_inf468 = and i1 %1870, %1872, !dbg !1096
  %1873 = bitcast float %1380 to i32, !dbg !1096
  %1874 = and i32 %1873, 2147483647, !dbg !1096
  %is_zero469 = icmp eq i32 %1874, 0, !dbg !1096
  %1875 = and i1 %is_inf468, %is_zero469, !dbg !1096
  %1876 = or i1 %1867, %1875, !dbg !1096
  %1877 = or i1 %1859, %1876, !dbg !1096
  br i1 %1877, label %1878, label %1880, !dbg !1096

1878:                                             ; preds = %1841
  %1879 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1880, !dbg !1096

1880:                                             ; preds = %1841, %1878
  %1881 = call float @llvm.nvvm.fma.rn.f(float %1808, float %1380, float 0x3F92776E60000000) #5, !dbg !1096
  %1882 = bitcast float %1808 to i32, !dbg !1096
  %1883 = and i32 %1882, 2139095040, !dbg !1096
  %is_finite470 = icmp ne i32 %1883, 2139095040, !dbg !1096
  %1884 = and i1 true, %is_finite470, !dbg !1096
  %1885 = bitcast float %1380 to i32, !dbg !1096
  %1886 = and i32 %1885, 2139095040, !dbg !1096
  %is_finite471 = icmp ne i32 %1886, 2139095040, !dbg !1096
  %1887 = and i1 %1884, %is_finite471, !dbg !1096
  %1888 = bitcast float %1881 to i32, !dbg !1096
  %1889 = and i32 %1888, 2139095040, !dbg !1096
  %1890 = icmp eq i32 %1889, 2139095040, !dbg !1096
  %1891 = and i32 %1888, 8388607, !dbg !1096
  %1892 = icmp eq i32 %1891, 0, !dbg !1096
  %is_inf472 = and i1 %1890, %1892, !dbg !1096
  %1893 = bitcast float %1881 to i32, !dbg !1096
  %1894 = and i32 %1893, 2147483647, !dbg !1096
  %is_maxfinite473 = icmp eq i32 %1894, 2139095039, !dbg !1096
  %1895 = bitcast float %1881 to i32, !dbg !1096
  %1896 = and i32 %1895, -2147483648, !dbg !1096
  %1897 = icmp eq i32 %1896, 0, !dbg !1096
  %1898 = icmp ne i32 %1896, 0, !dbg !1096
  %is_pos_inf474 = and i1 %is_inf472, %1897, !dbg !1096
  %is_neg_inf475 = and i1 %is_inf472, %1898, !dbg !1096
  %is_pos_max476 = and i1 %is_maxfinite473, %1897, !dbg !1096
  %is_neg_max477 = and i1 %is_maxfinite473, %1898, !dbg !1096
  %overflow_cond478 = and i1 %1887, %is_inf472, !dbg !1096
  br i1 %overflow_cond478, label %1899, label %1901, !dbg !1096

1899:                                             ; preds = %1880
  %1900 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1901, !dbg !1096

1901:                                             ; preds = %1880, %1899
  %1902 = bitcast float %1808 to i32, !dbg !1096
  %1903 = and i32 %1902, 2139095040, !dbg !1096
  %1904 = icmp eq i32 %1903, 0, !dbg !1096
  %1905 = and i32 %1902, 8388607, !dbg !1096
  %1906 = icmp ne i32 %1905, 0, !dbg !1096
  %is_subnormal479 = and i1 %1904, %1906, !dbg !1096
  %1907 = xor i1 %is_subnormal479, true, !dbg !1096
  %1908 = and i1 true, %1907, !dbg !1096
  %1909 = bitcast float %1380 to i32, !dbg !1096
  %1910 = and i32 %1909, 2139095040, !dbg !1096
  %1911 = icmp eq i32 %1910, 0, !dbg !1096
  %1912 = and i32 %1909, 8388607, !dbg !1096
  %1913 = icmp ne i32 %1912, 0, !dbg !1096
  %is_subnormal480 = and i1 %1911, %1913, !dbg !1096
  %1914 = xor i1 %is_subnormal480, true, !dbg !1096
  %1915 = and i1 %1908, %1914, !dbg !1096
  %1916 = and i1 %1915, true, !dbg !1096
  %1917 = bitcast float %1881 to i32, !dbg !1096
  %1918 = and i32 %1917, 2139095040, !dbg !1096
  %1919 = icmp eq i32 %1918, 0, !dbg !1096
  %1920 = and i32 %1917, 8388607, !dbg !1096
  %1921 = icmp ne i32 %1920, 0, !dbg !1096
  %is_subnormal481 = and i1 %1919, %1921, !dbg !1096
  %is_tiny482 = or i1 %is_subnormal481, false, !dbg !1096
  %underflow_cond483 = and i1 %1916, %is_tiny482, !dbg !1096
  br i1 %underflow_cond483, label %1922, label %1924, !dbg !1096

1922:                                             ; preds = %1901
  %1923 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1924, !dbg !1096

1924:                                             ; preds = %1901, %1922
  %1925 = bitcast float %1881 to i32, !dbg !1096
  %1926 = bitcast float %1881 to i32, !dbg !1096
  %1927 = and i32 %1926, 2139095040, !dbg !1096
  %1928 = icmp eq i32 %1927, 2139095040, !dbg !1096
  %1929 = and i32 %1926, 8388607, !dbg !1096
  %1930 = icmp ne i32 %1929, 0, !dbg !1096
  %is_nan484 = and i1 %1928, %1930, !dbg !1096
  %1931 = and i32 %1925, 4194304, !dbg !1096
  %1932 = icmp eq i32 %1931, 0, !dbg !1096
  %is_snan485 = and i1 %is_nan484, %1932, !dbg !1096
  %1933 = bitcast float %1380 to i32, !dbg !1096
  %1934 = bitcast float %1380 to i32, !dbg !1096
  %1935 = and i32 %1934, 2139095040, !dbg !1096
  %1936 = icmp eq i32 %1935, 2139095040, !dbg !1096
  %1937 = and i32 %1934, 8388607, !dbg !1096
  %1938 = icmp ne i32 %1937, 0, !dbg !1096
  %is_nan486 = and i1 %1936, %1938, !dbg !1096
  %1939 = and i32 %1933, 4194304, !dbg !1096
  %1940 = icmp eq i32 %1939, 0, !dbg !1096
  %is_snan487 = and i1 %is_nan486, %1940, !dbg !1096
  %1941 = or i1 %is_snan485, %is_snan487, !dbg !1096
  %1942 = or i1 %1941, false, !dbg !1096
  %1943 = bitcast float %1881 to i32, !dbg !1096
  %1944 = and i32 %1943, 2147483647, !dbg !1096
  %is_zero488 = icmp eq i32 %1944, 0, !dbg !1096
  %1945 = bitcast float %1380 to i32, !dbg !1096
  %1946 = and i32 %1945, 2139095040, !dbg !1096
  %1947 = icmp eq i32 %1946, 2139095040, !dbg !1096
  %1948 = and i32 %1945, 8388607, !dbg !1096
  %1949 = icmp eq i32 %1948, 0, !dbg !1096
  %is_inf489 = and i1 %1947, %1949, !dbg !1096
  %1950 = and i1 %is_zero488, %is_inf489, !dbg !1096
  %1951 = bitcast float %1881 to i32, !dbg !1096
  %1952 = and i32 %1951, 2139095040, !dbg !1096
  %1953 = icmp eq i32 %1952, 2139095040, !dbg !1096
  %1954 = and i32 %1951, 8388607, !dbg !1096
  %1955 = icmp eq i32 %1954, 0, !dbg !1096
  %is_inf490 = and i1 %1953, %1955, !dbg !1096
  %1956 = bitcast float %1380 to i32, !dbg !1096
  %1957 = and i32 %1956, 2147483647, !dbg !1096
  %is_zero491 = icmp eq i32 %1957, 0, !dbg !1096
  %1958 = and i1 %is_inf490, %is_zero491, !dbg !1096
  %1959 = or i1 %1950, %1958, !dbg !1096
  %1960 = or i1 %1942, %1959, !dbg !1096
  br i1 %1960, label %1961, label %1963, !dbg !1096

1961:                                             ; preds = %1924
  %1962 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1963, !dbg !1096

1963:                                             ; preds = %1924, %1961
  %1964 = call float @llvm.nvvm.fma.rn.f(float %1881, float %1380, float 0x3FBEC709E0000000) #5, !dbg !1096
  %1965 = bitcast float %1881 to i32, !dbg !1096
  %1966 = and i32 %1965, 2139095040, !dbg !1096
  %is_finite492 = icmp ne i32 %1966, 2139095040, !dbg !1096
  %1967 = and i1 true, %is_finite492, !dbg !1096
  %1968 = bitcast float %1380 to i32, !dbg !1096
  %1969 = and i32 %1968, 2139095040, !dbg !1096
  %is_finite493 = icmp ne i32 %1969, 2139095040, !dbg !1096
  %1970 = and i1 %1967, %is_finite493, !dbg !1096
  %1971 = bitcast float %1964 to i32, !dbg !1096
  %1972 = and i32 %1971, 2139095040, !dbg !1096
  %1973 = icmp eq i32 %1972, 2139095040, !dbg !1096
  %1974 = and i32 %1971, 8388607, !dbg !1096
  %1975 = icmp eq i32 %1974, 0, !dbg !1096
  %is_inf494 = and i1 %1973, %1975, !dbg !1096
  %1976 = bitcast float %1964 to i32, !dbg !1096
  %1977 = and i32 %1976, 2147483647, !dbg !1096
  %is_maxfinite495 = icmp eq i32 %1977, 2139095039, !dbg !1096
  %1978 = bitcast float %1964 to i32, !dbg !1096
  %1979 = and i32 %1978, -2147483648, !dbg !1096
  %1980 = icmp eq i32 %1979, 0, !dbg !1096
  %1981 = icmp ne i32 %1979, 0, !dbg !1096
  %is_pos_inf496 = and i1 %is_inf494, %1980, !dbg !1096
  %is_neg_inf497 = and i1 %is_inf494, %1981, !dbg !1096
  %is_pos_max498 = and i1 %is_maxfinite495, %1980, !dbg !1096
  %is_neg_max499 = and i1 %is_maxfinite495, %1981, !dbg !1096
  %overflow_cond500 = and i1 %1970, %is_inf494, !dbg !1096
  br i1 %overflow_cond500, label %1982, label %1984, !dbg !1096

1982:                                             ; preds = %1963
  %1983 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %1984, !dbg !1096

1984:                                             ; preds = %1963, %1982
  %1985 = bitcast float %1881 to i32, !dbg !1096
  %1986 = and i32 %1985, 2139095040, !dbg !1096
  %1987 = icmp eq i32 %1986, 0, !dbg !1096
  %1988 = and i32 %1985, 8388607, !dbg !1096
  %1989 = icmp ne i32 %1988, 0, !dbg !1096
  %is_subnormal501 = and i1 %1987, %1989, !dbg !1096
  %1990 = xor i1 %is_subnormal501, true, !dbg !1096
  %1991 = and i1 true, %1990, !dbg !1096
  %1992 = bitcast float %1380 to i32, !dbg !1096
  %1993 = and i32 %1992, 2139095040, !dbg !1096
  %1994 = icmp eq i32 %1993, 0, !dbg !1096
  %1995 = and i32 %1992, 8388607, !dbg !1096
  %1996 = icmp ne i32 %1995, 0, !dbg !1096
  %is_subnormal502 = and i1 %1994, %1996, !dbg !1096
  %1997 = xor i1 %is_subnormal502, true, !dbg !1096
  %1998 = and i1 %1991, %1997, !dbg !1096
  %1999 = and i1 %1998, true, !dbg !1096
  %2000 = bitcast float %1964 to i32, !dbg !1096
  %2001 = and i32 %2000, 2139095040, !dbg !1096
  %2002 = icmp eq i32 %2001, 0, !dbg !1096
  %2003 = and i32 %2000, 8388607, !dbg !1096
  %2004 = icmp ne i32 %2003, 0, !dbg !1096
  %is_subnormal503 = and i1 %2002, %2004, !dbg !1096
  %is_tiny504 = or i1 %is_subnormal503, false, !dbg !1096
  %underflow_cond505 = and i1 %1999, %is_tiny504, !dbg !1096
  br i1 %underflow_cond505, label %2005, label %2007, !dbg !1096

2005:                                             ; preds = %1984
  %2006 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2007, !dbg !1096

2007:                                             ; preds = %1984, %2005
  %2008 = bitcast float %1964 to i32, !dbg !1096
  %2009 = bitcast float %1964 to i32, !dbg !1096
  %2010 = and i32 %2009, 2139095040, !dbg !1096
  %2011 = icmp eq i32 %2010, 2139095040, !dbg !1096
  %2012 = and i32 %2009, 8388607, !dbg !1096
  %2013 = icmp ne i32 %2012, 0, !dbg !1096
  %is_nan506 = and i1 %2011, %2013, !dbg !1096
  %2014 = and i32 %2008, 4194304, !dbg !1096
  %2015 = icmp eq i32 %2014, 0, !dbg !1096
  %is_snan507 = and i1 %is_nan506, %2015, !dbg !1096
  %2016 = bitcast float %1380 to i32, !dbg !1096
  %2017 = bitcast float %1380 to i32, !dbg !1096
  %2018 = and i32 %2017, 2139095040, !dbg !1096
  %2019 = icmp eq i32 %2018, 2139095040, !dbg !1096
  %2020 = and i32 %2017, 8388607, !dbg !1096
  %2021 = icmp ne i32 %2020, 0, !dbg !1096
  %is_nan508 = and i1 %2019, %2021, !dbg !1096
  %2022 = and i32 %2016, 4194304, !dbg !1096
  %2023 = icmp eq i32 %2022, 0, !dbg !1096
  %is_snan509 = and i1 %is_nan508, %2023, !dbg !1096
  %2024 = or i1 %is_snan507, %is_snan509, !dbg !1096
  %2025 = bitcast float %1964 to i32, !dbg !1096
  %2026 = and i32 %2025, 2147483647, !dbg !1096
  %is_zero510 = icmp eq i32 %2026, 0, !dbg !1096
  %2027 = bitcast float %1380 to i32, !dbg !1096
  %2028 = and i32 %2027, 2139095040, !dbg !1096
  %2029 = icmp eq i32 %2028, 2139095040, !dbg !1096
  %2030 = and i32 %2027, 8388607, !dbg !1096
  %2031 = icmp eq i32 %2030, 0, !dbg !1096
  %is_inf511 = and i1 %2029, %2031, !dbg !1096
  %2032 = and i1 %is_zero510, %is_inf511, !dbg !1096
  %2033 = bitcast float %1964 to i32, !dbg !1096
  %2034 = and i32 %2033, 2139095040, !dbg !1096
  %2035 = icmp eq i32 %2034, 2139095040, !dbg !1096
  %2036 = and i32 %2033, 8388607, !dbg !1096
  %2037 = icmp eq i32 %2036, 0, !dbg !1096
  %is_inf512 = and i1 %2035, %2037, !dbg !1096
  %2038 = bitcast float %1380 to i32, !dbg !1096
  %2039 = and i32 %2038, 2147483647, !dbg !1096
  %is_zero513 = icmp eq i32 %2039, 0, !dbg !1096
  %2040 = and i1 %is_inf512, %is_zero513, !dbg !1096
  %2041 = or i1 %2032, %2040, !dbg !1096
  %2042 = or i1 %2024, %2041, !dbg !1096
  br i1 %2042, label %2043, label %2045, !dbg !1096

2043:                                             ; preds = %2007
  %2044 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2045, !dbg !1096

2045:                                             ; preds = %2007, %2043
  %2046 = call float @llvm.nvvm.mul.rn.f(float %1964, float %1380) #5, !dbg !1096
  %2047 = bitcast float %1964 to i32, !dbg !1096
  %2048 = and i32 %2047, 2139095040, !dbg !1096
  %is_finite514 = icmp ne i32 %2048, 2139095040, !dbg !1096
  %2049 = and i1 true, %is_finite514, !dbg !1096
  %2050 = bitcast float %1380 to i32, !dbg !1096
  %2051 = and i32 %2050, 2139095040, !dbg !1096
  %is_finite515 = icmp ne i32 %2051, 2139095040, !dbg !1096
  %2052 = and i1 %2049, %is_finite515, !dbg !1096
  %2053 = bitcast float %2046 to i32, !dbg !1096
  %2054 = and i32 %2053, 2139095040, !dbg !1096
  %2055 = icmp eq i32 %2054, 2139095040, !dbg !1096
  %2056 = and i32 %2053, 8388607, !dbg !1096
  %2057 = icmp eq i32 %2056, 0, !dbg !1096
  %is_inf516 = and i1 %2055, %2057, !dbg !1096
  %2058 = bitcast float %2046 to i32, !dbg !1096
  %2059 = and i32 %2058, 2147483647, !dbg !1096
  %is_maxfinite517 = icmp eq i32 %2059, 2139095039, !dbg !1096
  %2060 = bitcast float %2046 to i32, !dbg !1096
  %2061 = and i32 %2060, -2147483648, !dbg !1096
  %2062 = icmp eq i32 %2061, 0, !dbg !1096
  %2063 = icmp ne i32 %2061, 0, !dbg !1096
  %is_pos_inf518 = and i1 %is_inf516, %2062, !dbg !1096
  %is_neg_inf519 = and i1 %is_inf516, %2063, !dbg !1096
  %is_pos_max520 = and i1 %is_maxfinite517, %2062, !dbg !1096
  %is_neg_max521 = and i1 %is_maxfinite517, %2063, !dbg !1096
  %overflow_cond522 = and i1 %2052, %is_inf516, !dbg !1096
  br i1 %overflow_cond522, label %2064, label %2066, !dbg !1096

2064:                                             ; preds = %2045
  %2065 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2066, !dbg !1096

2066:                                             ; preds = %2045, %2064
  %2067 = bitcast float %1964 to i32, !dbg !1096
  %2068 = and i32 %2067, 2139095040, !dbg !1096
  %2069 = icmp eq i32 %2068, 0, !dbg !1096
  %2070 = and i32 %2067, 8388607, !dbg !1096
  %2071 = icmp ne i32 %2070, 0, !dbg !1096
  %is_subnormal523 = and i1 %2069, %2071, !dbg !1096
  %2072 = xor i1 %is_subnormal523, true, !dbg !1096
  %2073 = and i1 true, %2072, !dbg !1096
  %2074 = bitcast float %1380 to i32, !dbg !1096
  %2075 = and i32 %2074, 2139095040, !dbg !1096
  %2076 = icmp eq i32 %2075, 0, !dbg !1096
  %2077 = and i32 %2074, 8388607, !dbg !1096
  %2078 = icmp ne i32 %2077, 0, !dbg !1096
  %is_subnormal524 = and i1 %2076, %2078, !dbg !1096
  %2079 = xor i1 %is_subnormal524, true, !dbg !1096
  %2080 = and i1 %2073, %2079, !dbg !1096
  %2081 = bitcast float %2046 to i32, !dbg !1096
  %2082 = and i32 %2081, 2139095040, !dbg !1096
  %2083 = icmp eq i32 %2082, 0, !dbg !1096
  %2084 = and i32 %2081, 8388607, !dbg !1096
  %2085 = icmp ne i32 %2084, 0, !dbg !1096
  %is_subnormal525 = and i1 %2083, %2085, !dbg !1096
  %2086 = bitcast float %2046 to i32, !dbg !1096
  %2087 = and i32 %2086, 2147483647, !dbg !1096
  %is_zero526 = icmp eq i32 %2087, 0, !dbg !1096
  %2088 = bitcast float %1964 to i32, !dbg !1096
  %2089 = and i32 %2088, 2147483647, !dbg !1096
  %is_zero527 = icmp eq i32 %2089, 0, !dbg !1096
  %2090 = xor i1 %is_zero527, true, !dbg !1096
  %2091 = bitcast float %1380 to i32, !dbg !1096
  %2092 = and i32 %2091, 2147483647, !dbg !1096
  %is_zero528 = icmp eq i32 %2092, 0, !dbg !1096
  %2093 = xor i1 %is_zero528, true, !dbg !1096
  %2094 = and i1 %2090, %2093, !dbg !1096
  %2095 = and i1 %is_zero526, %2094, !dbg !1096
  %is_tiny529 = or i1 %is_subnormal525, %2095, !dbg !1096
  %underflow_cond530 = and i1 %2080, %is_tiny529, !dbg !1096
  br i1 %underflow_cond530, label %2096, label %2098, !dbg !1096

2096:                                             ; preds = %2066
  %2097 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2098, !dbg !1096

2098:                                             ; preds = %2066, %2096
  %2099 = bitcast float %1289 to i32, !dbg !1096
  %2100 = bitcast float %1289 to i32, !dbg !1096
  %2101 = and i32 %2100, 2139095040, !dbg !1096
  %2102 = icmp eq i32 %2101, 2139095040, !dbg !1096
  %2103 = and i32 %2100, 8388607, !dbg !1096
  %2104 = icmp ne i32 %2103, 0, !dbg !1096
  %is_nan531 = and i1 %2102, %2104, !dbg !1096
  %2105 = and i32 %2099, 4194304, !dbg !1096
  %2106 = icmp eq i32 %2105, 0, !dbg !1096
  %is_snan532 = and i1 %is_nan531, %2106, !dbg !1096
  %2107 = or i1 %is_snan532, false, !dbg !1096
  %2108 = bitcast float %1061 to i32, !dbg !1096
  %2109 = bitcast float %1061 to i32, !dbg !1096
  %2110 = and i32 %2109, 2139095040, !dbg !1096
  %2111 = icmp eq i32 %2110, 2139095040, !dbg !1096
  %2112 = and i32 %2109, 8388607, !dbg !1096
  %2113 = icmp ne i32 %2112, 0, !dbg !1096
  %is_nan533 = and i1 %2111, %2113, !dbg !1096
  %2114 = and i32 %2108, 4194304, !dbg !1096
  %2115 = icmp eq i32 %2114, 0, !dbg !1096
  %is_snan534 = and i1 %is_nan533, %2115, !dbg !1096
  %2116 = or i1 %2107, %is_snan534, !dbg !1096
  %2117 = bitcast float %1289 to i32, !dbg !1096
  %2118 = and i32 %2117, 2147483647, !dbg !1096
  %is_zero535 = icmp eq i32 %2118, 0, !dbg !1096
  %2119 = and i1 %is_zero535, false, !dbg !1096
  %2120 = bitcast float %1289 to i32, !dbg !1096
  %2121 = and i32 %2120, 2139095040, !dbg !1096
  %2122 = icmp eq i32 %2121, 2139095040, !dbg !1096
  %2123 = and i32 %2120, 8388607, !dbg !1096
  %2124 = icmp eq i32 %2123, 0, !dbg !1096
  %is_inf536 = and i1 %2122, %2124, !dbg !1096
  %2125 = and i1 %is_inf536, false, !dbg !1096
  %2126 = or i1 %2119, %2125, !dbg !1096
  %2127 = or i1 %2116, %2126, !dbg !1096
  br i1 %2127, label %2128, label %2130, !dbg !1096

2128:                                             ; preds = %2098
  %2129 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2130, !dbg !1096

2130:                                             ; preds = %2098, %2128
  %2131 = call float @llvm.nvvm.fma.rn.f(float %1289, float 0x3FF7154760000000, float %1061) #5, !dbg !1096
  %2132 = bitcast float %1289 to i32, !dbg !1096
  %2133 = and i32 %2132, 2139095040, !dbg !1096
  %is_finite537 = icmp ne i32 %2133, 2139095040, !dbg !1096
  %2134 = and i1 true, %is_finite537, !dbg !1096
  %2135 = and i1 %2134, true, !dbg !1096
  %2136 = bitcast float %2131 to i32, !dbg !1096
  %2137 = and i32 %2136, 2139095040, !dbg !1096
  %2138 = icmp eq i32 %2137, 2139095040, !dbg !1096
  %2139 = and i32 %2136, 8388607, !dbg !1096
  %2140 = icmp eq i32 %2139, 0, !dbg !1096
  %is_inf538 = and i1 %2138, %2140, !dbg !1096
  %2141 = bitcast float %2131 to i32, !dbg !1096
  %2142 = and i32 %2141, 2147483647, !dbg !1096
  %is_maxfinite539 = icmp eq i32 %2142, 2139095039, !dbg !1096
  %2143 = bitcast float %2131 to i32, !dbg !1096
  %2144 = and i32 %2143, -2147483648, !dbg !1096
  %2145 = icmp eq i32 %2144, 0, !dbg !1096
  %2146 = icmp ne i32 %2144, 0, !dbg !1096
  %is_pos_inf540 = and i1 %is_inf538, %2145, !dbg !1096
  %is_neg_inf541 = and i1 %is_inf538, %2146, !dbg !1096
  %is_pos_max542 = and i1 %is_maxfinite539, %2145, !dbg !1096
  %is_neg_max543 = and i1 %is_maxfinite539, %2146, !dbg !1096
  %overflow_cond544 = and i1 %2135, %is_inf538, !dbg !1096
  br i1 %overflow_cond544, label %2147, label %2149, !dbg !1096

2147:                                             ; preds = %2130
  %2148 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2149, !dbg !1096

2149:                                             ; preds = %2130, %2147
  %2150 = bitcast float %1289 to i32, !dbg !1096
  %2151 = and i32 %2150, 2139095040, !dbg !1096
  %2152 = icmp eq i32 %2151, 0, !dbg !1096
  %2153 = and i32 %2150, 8388607, !dbg !1096
  %2154 = icmp ne i32 %2153, 0, !dbg !1096
  %is_subnormal545 = and i1 %2152, %2154, !dbg !1096
  %2155 = xor i1 %is_subnormal545, true, !dbg !1096
  %2156 = and i1 true, %2155, !dbg !1096
  %2157 = and i1 %2156, true, !dbg !1096
  %2158 = bitcast float %1061 to i32, !dbg !1096
  %2159 = and i32 %2158, 2139095040, !dbg !1096
  %2160 = icmp eq i32 %2159, 0, !dbg !1096
  %2161 = and i32 %2158, 8388607, !dbg !1096
  %2162 = icmp ne i32 %2161, 0, !dbg !1096
  %is_subnormal546 = and i1 %2160, %2162, !dbg !1096
  %2163 = xor i1 %is_subnormal546, true, !dbg !1096
  %2164 = and i1 %2157, %2163, !dbg !1096
  %2165 = bitcast float %2131 to i32, !dbg !1096
  %2166 = and i32 %2165, 2139095040, !dbg !1096
  %2167 = icmp eq i32 %2166, 0, !dbg !1096
  %2168 = and i32 %2165, 8388607, !dbg !1096
  %2169 = icmp ne i32 %2168, 0, !dbg !1096
  %is_subnormal547 = and i1 %2167, %2169, !dbg !1096
  %is_tiny548 = or i1 %is_subnormal547, false, !dbg !1096
  %underflow_cond549 = and i1 %2164, %is_tiny548, !dbg !1096
  br i1 %underflow_cond549, label %2170, label %2172, !dbg !1096

2170:                                             ; preds = %2149
  %2171 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2172, !dbg !1096

2172:                                             ; preds = %2149, %2170
  %2173 = bitcast float %1061 to i32, !dbg !1096
  %2174 = bitcast float %1061 to i32, !dbg !1096
  %2175 = and i32 %2174, 2139095040, !dbg !1096
  %2176 = icmp eq i32 %2175, 2139095040, !dbg !1096
  %2177 = and i32 %2174, 8388607, !dbg !1096
  %2178 = icmp ne i32 %2177, 0, !dbg !1096
  %is_nan550 = and i1 %2176, %2178, !dbg !1096
  %2179 = and i32 %2173, 4194304, !dbg !1096
  %2180 = icmp eq i32 %2179, 0, !dbg !1096
  %is_snan551 = and i1 %is_nan550, %2180, !dbg !1096
  %2181 = bitcast float %2131 to i32, !dbg !1096
  %2182 = bitcast float %2131 to i32, !dbg !1096
  %2183 = and i32 %2182, 2139095040, !dbg !1096
  %2184 = icmp eq i32 %2183, 2139095040, !dbg !1096
  %2185 = and i32 %2182, 8388607, !dbg !1096
  %2186 = icmp ne i32 %2185, 0, !dbg !1096
  %is_nan552 = and i1 %2184, %2186, !dbg !1096
  %2187 = and i32 %2181, 4194304, !dbg !1096
  %2188 = icmp eq i32 %2187, 0, !dbg !1096
  %is_snan553 = and i1 %is_nan552, %2188, !dbg !1096
  %2189 = or i1 %is_snan551, %is_snan553, !dbg !1096
  %2190 = bitcast float %1061 to i32, !dbg !1096
  %2191 = and i32 %2190, 2139095040, !dbg !1096
  %2192 = icmp eq i32 %2191, 2139095040, !dbg !1096
  %2193 = and i32 %2190, 8388607, !dbg !1096
  %2194 = icmp eq i32 %2193, 0, !dbg !1096
  %is_inf554 = and i1 %2192, %2194, !dbg !1096
  %2195 = bitcast float %2131 to i32, !dbg !1096
  %2196 = and i32 %2195, 2139095040, !dbg !1096
  %2197 = icmp eq i32 %2196, 2139095040, !dbg !1096
  %2198 = and i32 %2195, 8388607, !dbg !1096
  %2199 = icmp eq i32 %2198, 0, !dbg !1096
  %is_inf555 = and i1 %2197, %2199, !dbg !1096
  %2200 = and i1 %is_inf554, %is_inf555, !dbg !1096
  %2201 = bitcast float %1061 to i32, !dbg !1096
  %2202 = bitcast float %2131 to i32, !dbg !1096
  %2203 = and i32 %2201, -2147483648, !dbg !1096
  %2204 = and i32 %2202, -2147483648, !dbg !1096
  %2205 = icmp eq i32 %2203, %2204, !dbg !1096
  %2206 = and i1 %2200, %2205, !dbg !1096
  %2207 = or i1 %2189, %2206, !dbg !1096
  br i1 %2207, label %2208, label %2210, !dbg !1096

2208:                                             ; preds = %2172
  %2209 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2210, !dbg !1096

2210:                                             ; preds = %2172, %2208
  %2211 = fsub float %1061, %2131, !dbg !1096
  %2212 = bitcast float %1061 to i32, !dbg !1096
  %2213 = and i32 %2212, 2139095040, !dbg !1096
  %is_finite556 = icmp ne i32 %2213, 2139095040, !dbg !1096
  %2214 = and i1 true, %is_finite556, !dbg !1096
  %2215 = bitcast float %2131 to i32, !dbg !1096
  %2216 = and i32 %2215, 2139095040, !dbg !1096
  %is_finite557 = icmp ne i32 %2216, 2139095040, !dbg !1096
  %2217 = and i1 %2214, %is_finite557, !dbg !1096
  %2218 = bitcast float %2211 to i32, !dbg !1096
  %2219 = and i32 %2218, 2139095040, !dbg !1096
  %2220 = icmp eq i32 %2219, 2139095040, !dbg !1096
  %2221 = and i32 %2218, 8388607, !dbg !1096
  %2222 = icmp eq i32 %2221, 0, !dbg !1096
  %is_inf558 = and i1 %2220, %2222, !dbg !1096
  %2223 = bitcast float %2211 to i32, !dbg !1096
  %2224 = and i32 %2223, 2147483647, !dbg !1096
  %is_maxfinite559 = icmp eq i32 %2224, 2139095039, !dbg !1096
  %2225 = bitcast float %2211 to i32, !dbg !1096
  %2226 = and i32 %2225, -2147483648, !dbg !1096
  %2227 = icmp eq i32 %2226, 0, !dbg !1096
  %2228 = icmp ne i32 %2226, 0, !dbg !1096
  %is_pos_inf560 = and i1 %is_inf558, %2227, !dbg !1096
  %is_neg_inf561 = and i1 %is_inf558, %2228, !dbg !1096
  %is_pos_max562 = and i1 %is_maxfinite559, %2227, !dbg !1096
  %is_neg_max563 = and i1 %is_maxfinite559, %2228, !dbg !1096
  %overflow_cond564 = and i1 %2217, %is_inf558, !dbg !1096
  br i1 %overflow_cond564, label %2229, label %2231, !dbg !1096

2229:                                             ; preds = %2210
  %2230 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2231, !dbg !1096

2231:                                             ; preds = %2210, %2229
  %2232 = bitcast float %1289 to i32, !dbg !1096
  %2233 = bitcast float %1289 to i32, !dbg !1096
  %2234 = and i32 %2233, 2139095040, !dbg !1096
  %2235 = icmp eq i32 %2234, 2139095040, !dbg !1096
  %2236 = and i32 %2233, 8388607, !dbg !1096
  %2237 = icmp ne i32 %2236, 0, !dbg !1096
  %is_nan565 = and i1 %2235, %2237, !dbg !1096
  %2238 = and i32 %2232, 4194304, !dbg !1096
  %2239 = icmp eq i32 %2238, 0, !dbg !1096
  %is_snan566 = and i1 %is_nan565, %2239, !dbg !1096
  %2240 = or i1 %is_snan566, false, !dbg !1096
  %2241 = bitcast float %2211 to i32, !dbg !1096
  %2242 = bitcast float %2211 to i32, !dbg !1096
  %2243 = and i32 %2242, 2139095040, !dbg !1096
  %2244 = icmp eq i32 %2243, 2139095040, !dbg !1096
  %2245 = and i32 %2242, 8388607, !dbg !1096
  %2246 = icmp ne i32 %2245, 0, !dbg !1096
  %is_nan567 = and i1 %2244, %2246, !dbg !1096
  %2247 = and i32 %2241, 4194304, !dbg !1096
  %2248 = icmp eq i32 %2247, 0, !dbg !1096
  %is_snan568 = and i1 %is_nan567, %2248, !dbg !1096
  %2249 = or i1 %2240, %is_snan568, !dbg !1096
  %2250 = bitcast float %1289 to i32, !dbg !1096
  %2251 = and i32 %2250, 2147483647, !dbg !1096
  %is_zero569 = icmp eq i32 %2251, 0, !dbg !1096
  %2252 = and i1 %is_zero569, false, !dbg !1096
  %2253 = bitcast float %1289 to i32, !dbg !1096
  %2254 = and i32 %2253, 2139095040, !dbg !1096
  %2255 = icmp eq i32 %2254, 2139095040, !dbg !1096
  %2256 = and i32 %2253, 8388607, !dbg !1096
  %2257 = icmp eq i32 %2256, 0, !dbg !1096
  %is_inf570 = and i1 %2255, %2257, !dbg !1096
  %2258 = and i1 %is_inf570, false, !dbg !1096
  %2259 = or i1 %2252, %2258, !dbg !1096
  %2260 = or i1 %2249, %2259, !dbg !1096
  br i1 %2260, label %2261, label %2263, !dbg !1096

2261:                                             ; preds = %2231
  %2262 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2263, !dbg !1096

2263:                                             ; preds = %2231, %2261
  %2264 = call float @llvm.nvvm.fma.rn.f(float %1289, float 0x3FF7154760000000, float %2211) #5, !dbg !1096
  %2265 = bitcast float %1289 to i32, !dbg !1096
  %2266 = and i32 %2265, 2139095040, !dbg !1096
  %is_finite571 = icmp ne i32 %2266, 2139095040, !dbg !1096
  %2267 = and i1 true, %is_finite571, !dbg !1096
  %2268 = and i1 %2267, true, !dbg !1096
  %2269 = bitcast float %2264 to i32, !dbg !1096
  %2270 = and i32 %2269, 2139095040, !dbg !1096
  %2271 = icmp eq i32 %2270, 2139095040, !dbg !1096
  %2272 = and i32 %2269, 8388607, !dbg !1096
  %2273 = icmp eq i32 %2272, 0, !dbg !1096
  %is_inf572 = and i1 %2271, %2273, !dbg !1096
  %2274 = bitcast float %2264 to i32, !dbg !1096
  %2275 = and i32 %2274, 2147483647, !dbg !1096
  %is_maxfinite573 = icmp eq i32 %2275, 2139095039, !dbg !1096
  %2276 = bitcast float %2264 to i32, !dbg !1096
  %2277 = and i32 %2276, -2147483648, !dbg !1096
  %2278 = icmp eq i32 %2277, 0, !dbg !1096
  %2279 = icmp ne i32 %2277, 0, !dbg !1096
  %is_pos_inf574 = and i1 %is_inf572, %2278, !dbg !1096
  %is_neg_inf575 = and i1 %is_inf572, %2279, !dbg !1096
  %is_pos_max576 = and i1 %is_maxfinite573, %2278, !dbg !1096
  %is_neg_max577 = and i1 %is_maxfinite573, %2279, !dbg !1096
  %overflow_cond578 = and i1 %2268, %is_inf572, !dbg !1096
  br i1 %overflow_cond578, label %2280, label %2282, !dbg !1096

2280:                                             ; preds = %2263
  %2281 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2282, !dbg !1096

2282:                                             ; preds = %2263, %2280
  %2283 = bitcast float %1289 to i32, !dbg !1096
  %2284 = and i32 %2283, 2139095040, !dbg !1096
  %2285 = icmp eq i32 %2284, 0, !dbg !1096
  %2286 = and i32 %2283, 8388607, !dbg !1096
  %2287 = icmp ne i32 %2286, 0, !dbg !1096
  %is_subnormal579 = and i1 %2285, %2287, !dbg !1096
  %2288 = xor i1 %is_subnormal579, true, !dbg !1096
  %2289 = and i1 true, %2288, !dbg !1096
  %2290 = and i1 %2289, true, !dbg !1096
  %2291 = bitcast float %2211 to i32, !dbg !1096
  %2292 = and i32 %2291, 2139095040, !dbg !1096
  %2293 = icmp eq i32 %2292, 0, !dbg !1096
  %2294 = and i32 %2291, 8388607, !dbg !1096
  %2295 = icmp ne i32 %2294, 0, !dbg !1096
  %is_subnormal580 = and i1 %2293, %2295, !dbg !1096
  %2296 = xor i1 %is_subnormal580, true, !dbg !1096
  %2297 = and i1 %2290, %2296, !dbg !1096
  %2298 = bitcast float %2264 to i32, !dbg !1096
  %2299 = and i32 %2298, 2139095040, !dbg !1096
  %2300 = icmp eq i32 %2299, 0, !dbg !1096
  %2301 = and i32 %2298, 8388607, !dbg !1096
  %2302 = icmp ne i32 %2301, 0, !dbg !1096
  %is_subnormal581 = and i1 %2300, %2302, !dbg !1096
  %is_tiny582 = or i1 %is_subnormal581, false, !dbg !1096
  %underflow_cond583 = and i1 %2297, %is_tiny582, !dbg !1096
  br i1 %underflow_cond583, label %2303, label %2305, !dbg !1096

2303:                                             ; preds = %2282
  %2304 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2305, !dbg !1096

2305:                                             ; preds = %2282, %2303
  %insert87.i = insertvalue %struct.float2 undef, float %2131, 0, !dbg !1096
  %insert89.i = insertvalue %struct.float2 %insert87.i, float %2264, 1, !dbg !1096
  %2306 = bitcast float %1731 to i32, !dbg !1096
  %2307 = bitcast float %1731 to i32, !dbg !1096
  %2308 = and i32 %2307, 2139095040, !dbg !1096
  %2309 = icmp eq i32 %2308, 2139095040, !dbg !1096
  %2310 = and i32 %2307, 8388607, !dbg !1096
  %2311 = icmp ne i32 %2310, 0, !dbg !1096
  %is_nan584 = and i1 %2309, %2311, !dbg !1096
  %2312 = and i32 %2306, 4194304, !dbg !1096
  %2313 = icmp eq i32 %2312, 0, !dbg !1096
  %is_snan585 = and i1 %is_nan584, %2313, !dbg !1096
  %2314 = or i1 %is_snan585, false, !dbg !1096
  %2315 = bitcast float %2264 to i32, !dbg !1096
  %2316 = bitcast float %2264 to i32, !dbg !1096
  %2317 = and i32 %2316, 2139095040, !dbg !1096
  %2318 = icmp eq i32 %2317, 2139095040, !dbg !1096
  %2319 = and i32 %2316, 8388607, !dbg !1096
  %2320 = icmp ne i32 %2319, 0, !dbg !1096
  %is_nan586 = and i1 %2318, %2320, !dbg !1096
  %2321 = and i32 %2315, 4194304, !dbg !1096
  %2322 = icmp eq i32 %2321, 0, !dbg !1096
  %is_snan587 = and i1 %is_nan586, %2322, !dbg !1096
  %2323 = or i1 %2314, %is_snan587, !dbg !1096
  %2324 = bitcast float %1731 to i32, !dbg !1096
  %2325 = and i32 %2324, 2147483647, !dbg !1096
  %is_zero588 = icmp eq i32 %2325, 0, !dbg !1096
  %2326 = and i1 %is_zero588, false, !dbg !1096
  %2327 = bitcast float %1731 to i32, !dbg !1096
  %2328 = and i32 %2327, 2139095040, !dbg !1096
  %2329 = icmp eq i32 %2328, 2139095040, !dbg !1096
  %2330 = and i32 %2327, 8388607, !dbg !1096
  %2331 = icmp eq i32 %2330, 0, !dbg !1096
  %is_inf589 = and i1 %2329, %2331, !dbg !1096
  %2332 = and i1 %is_inf589, false, !dbg !1096
  %2333 = or i1 %2326, %2332, !dbg !1096
  %2334 = or i1 %2323, %2333, !dbg !1096
  br i1 %2334, label %2335, label %2337, !dbg !1096

2335:                                             ; preds = %2305
  %2336 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2337, !dbg !1096

2337:                                             ; preds = %2305, %2335
  %2338 = call float @llvm.nvvm.fma.rn.f(float %1731, float 0x3FF7154760000000, float %2264) #5, !dbg !1096
  %2339 = bitcast float %1731 to i32, !dbg !1096
  %2340 = and i32 %2339, 2139095040, !dbg !1096
  %is_finite590 = icmp ne i32 %2340, 2139095040, !dbg !1096
  %2341 = and i1 true, %is_finite590, !dbg !1096
  %2342 = and i1 %2341, true, !dbg !1096
  %2343 = bitcast float %2338 to i32, !dbg !1096
  %2344 = and i32 %2343, 2139095040, !dbg !1096
  %2345 = icmp eq i32 %2344, 2139095040, !dbg !1096
  %2346 = and i32 %2343, 8388607, !dbg !1096
  %2347 = icmp eq i32 %2346, 0, !dbg !1096
  %is_inf591 = and i1 %2345, %2347, !dbg !1096
  %2348 = bitcast float %2338 to i32, !dbg !1096
  %2349 = and i32 %2348, 2147483647, !dbg !1096
  %is_maxfinite592 = icmp eq i32 %2349, 2139095039, !dbg !1096
  %2350 = bitcast float %2338 to i32, !dbg !1096
  %2351 = and i32 %2350, -2147483648, !dbg !1096
  %2352 = icmp eq i32 %2351, 0, !dbg !1096
  %2353 = icmp ne i32 %2351, 0, !dbg !1096
  %is_pos_inf593 = and i1 %is_inf591, %2352, !dbg !1096
  %is_neg_inf594 = and i1 %is_inf591, %2353, !dbg !1096
  %is_pos_max595 = and i1 %is_maxfinite592, %2352, !dbg !1096
  %is_neg_max596 = and i1 %is_maxfinite592, %2353, !dbg !1096
  %overflow_cond597 = and i1 %2342, %is_inf591, !dbg !1096
  br i1 %overflow_cond597, label %2354, label %2356, !dbg !1096

2354:                                             ; preds = %2337
  %2355 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2356, !dbg !1096

2356:                                             ; preds = %2337, %2354
  %2357 = bitcast float %1731 to i32, !dbg !1096
  %2358 = and i32 %2357, 2139095040, !dbg !1096
  %2359 = icmp eq i32 %2358, 0, !dbg !1096
  %2360 = and i32 %2357, 8388607, !dbg !1096
  %2361 = icmp ne i32 %2360, 0, !dbg !1096
  %is_subnormal598 = and i1 %2359, %2361, !dbg !1096
  %2362 = xor i1 %is_subnormal598, true, !dbg !1096
  %2363 = and i1 true, %2362, !dbg !1096
  %2364 = and i1 %2363, true, !dbg !1096
  %2365 = bitcast float %2264 to i32, !dbg !1096
  %2366 = and i32 %2365, 2139095040, !dbg !1096
  %2367 = icmp eq i32 %2366, 0, !dbg !1096
  %2368 = and i32 %2365, 8388607, !dbg !1096
  %2369 = icmp ne i32 %2368, 0, !dbg !1096
  %is_subnormal599 = and i1 %2367, %2369, !dbg !1096
  %2370 = xor i1 %is_subnormal599, true, !dbg !1096
  %2371 = and i1 %2364, %2370, !dbg !1096
  %2372 = bitcast float %2338 to i32, !dbg !1096
  %2373 = and i32 %2372, 2139095040, !dbg !1096
  %2374 = icmp eq i32 %2373, 0, !dbg !1096
  %2375 = and i32 %2372, 8388607, !dbg !1096
  %2376 = icmp ne i32 %2375, 0, !dbg !1096
  %is_subnormal600 = and i1 %2374, %2376, !dbg !1096
  %is_tiny601 = or i1 %is_subnormal600, false, !dbg !1096
  %underflow_cond602 = and i1 %2371, %is_tiny601, !dbg !1096
  br i1 %underflow_cond602, label %2377, label %2379, !dbg !1096

2377:                                             ; preds = %2356
  %2378 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2379, !dbg !1096

2379:                                             ; preds = %2356, %2377
  %2380 = bitcast float %1289 to i32, !dbg !1096
  %2381 = bitcast float %1289 to i32, !dbg !1096
  %2382 = and i32 %2381, 2139095040, !dbg !1096
  %2383 = icmp eq i32 %2382, 2139095040, !dbg !1096
  %2384 = and i32 %2381, 8388607, !dbg !1096
  %2385 = icmp ne i32 %2384, 0, !dbg !1096
  %is_nan603 = and i1 %2383, %2385, !dbg !1096
  %2386 = and i32 %2380, 4194304, !dbg !1096
  %2387 = icmp eq i32 %2386, 0, !dbg !1096
  %is_snan604 = and i1 %is_nan603, %2387, !dbg !1096
  %2388 = or i1 %is_snan604, false, !dbg !1096
  %2389 = bitcast float %2338 to i32, !dbg !1096
  %2390 = bitcast float %2338 to i32, !dbg !1096
  %2391 = and i32 %2390, 2139095040, !dbg !1096
  %2392 = icmp eq i32 %2391, 2139095040, !dbg !1096
  %2393 = and i32 %2390, 8388607, !dbg !1096
  %2394 = icmp ne i32 %2393, 0, !dbg !1096
  %is_nan605 = and i1 %2392, %2394, !dbg !1096
  %2395 = and i32 %2389, 4194304, !dbg !1096
  %2396 = icmp eq i32 %2395, 0, !dbg !1096
  %is_snan606 = and i1 %is_nan605, %2396, !dbg !1096
  %2397 = or i1 %2388, %is_snan606, !dbg !1096
  %2398 = bitcast float %1289 to i32, !dbg !1096
  %2399 = and i32 %2398, 2147483647, !dbg !1096
  %is_zero607 = icmp eq i32 %2399, 0, !dbg !1096
  %2400 = and i1 %is_zero607, false, !dbg !1096
  %2401 = bitcast float %1289 to i32, !dbg !1096
  %2402 = and i32 %2401, 2139095040, !dbg !1096
  %2403 = icmp eq i32 %2402, 2139095040, !dbg !1096
  %2404 = and i32 %2401, 8388607, !dbg !1096
  %2405 = icmp eq i32 %2404, 0, !dbg !1096
  %is_inf608 = and i1 %2403, %2405, !dbg !1096
  %2406 = and i1 %is_inf608, false, !dbg !1096
  %2407 = or i1 %2400, %2406, !dbg !1096
  %2408 = or i1 %2397, %2407, !dbg !1096
  br i1 %2408, label %2409, label %2411, !dbg !1096

2409:                                             ; preds = %2379
  %2410 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2411, !dbg !1096

2411:                                             ; preds = %2379, %2409
  %2412 = call float @llvm.nvvm.fma.rn.f(float %1289, float 0x3E54ABC680000000, float %2338) #5, !dbg !1096
  %2413 = bitcast float %1289 to i32, !dbg !1096
  %2414 = and i32 %2413, 2139095040, !dbg !1096
  %is_finite609 = icmp ne i32 %2414, 2139095040, !dbg !1096
  %2415 = and i1 true, %is_finite609, !dbg !1096
  %2416 = and i1 %2415, true, !dbg !1096
  %2417 = bitcast float %2412 to i32, !dbg !1096
  %2418 = and i32 %2417, 2139095040, !dbg !1096
  %2419 = icmp eq i32 %2418, 2139095040, !dbg !1096
  %2420 = and i32 %2417, 8388607, !dbg !1096
  %2421 = icmp eq i32 %2420, 0, !dbg !1096
  %is_inf610 = and i1 %2419, %2421, !dbg !1096
  %2422 = bitcast float %2412 to i32, !dbg !1096
  %2423 = and i32 %2422, 2147483647, !dbg !1096
  %is_maxfinite611 = icmp eq i32 %2423, 2139095039, !dbg !1096
  %2424 = bitcast float %2412 to i32, !dbg !1096
  %2425 = and i32 %2424, -2147483648, !dbg !1096
  %2426 = icmp eq i32 %2425, 0, !dbg !1096
  %2427 = icmp ne i32 %2425, 0, !dbg !1096
  %is_pos_inf612 = and i1 %is_inf610, %2426, !dbg !1096
  %is_neg_inf613 = and i1 %is_inf610, %2427, !dbg !1096
  %is_pos_max614 = and i1 %is_maxfinite611, %2426, !dbg !1096
  %is_neg_max615 = and i1 %is_maxfinite611, %2427, !dbg !1096
  %overflow_cond616 = and i1 %2416, %is_inf610, !dbg !1096
  br i1 %overflow_cond616, label %2428, label %2430, !dbg !1096

2428:                                             ; preds = %2411
  %2429 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2430, !dbg !1096

2430:                                             ; preds = %2411, %2428
  %2431 = bitcast float %1289 to i32, !dbg !1096
  %2432 = and i32 %2431, 2139095040, !dbg !1096
  %2433 = icmp eq i32 %2432, 0, !dbg !1096
  %2434 = and i32 %2431, 8388607, !dbg !1096
  %2435 = icmp ne i32 %2434, 0, !dbg !1096
  %is_subnormal617 = and i1 %2433, %2435, !dbg !1096
  %2436 = xor i1 %is_subnormal617, true, !dbg !1096
  %2437 = and i1 true, %2436, !dbg !1096
  %2438 = and i1 %2437, true, !dbg !1096
  %2439 = bitcast float %2338 to i32, !dbg !1096
  %2440 = and i32 %2439, 2139095040, !dbg !1096
  %2441 = icmp eq i32 %2440, 0, !dbg !1096
  %2442 = and i32 %2439, 8388607, !dbg !1096
  %2443 = icmp ne i32 %2442, 0, !dbg !1096
  %is_subnormal618 = and i1 %2441, %2443, !dbg !1096
  %2444 = xor i1 %is_subnormal618, true, !dbg !1096
  %2445 = and i1 %2438, %2444, !dbg !1096
  %2446 = bitcast float %2412 to i32, !dbg !1096
  %2447 = and i32 %2446, 2139095040, !dbg !1096
  %2448 = icmp eq i32 %2447, 0, !dbg !1096
  %2449 = and i32 %2446, 8388607, !dbg !1096
  %2450 = icmp ne i32 %2449, 0, !dbg !1096
  %is_subnormal619 = and i1 %2448, %2450, !dbg !1096
  %is_tiny620 = or i1 %is_subnormal619, false, !dbg !1096
  %underflow_cond621 = and i1 %2445, %is_tiny620, !dbg !1096
  br i1 %underflow_cond621, label %2451, label %2453, !dbg !1096

2451:                                             ; preds = %2430
  %2452 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2453, !dbg !1096

2453:                                             ; preds = %2430, %2451
  %2454 = bitcast float %2046 to i32, !dbg !1096
  %2455 = bitcast float %2046 to i32, !dbg !1096
  %2456 = and i32 %2455, 2139095040, !dbg !1096
  %2457 = icmp eq i32 %2456, 2139095040, !dbg !1096
  %2458 = and i32 %2455, 8388607, !dbg !1096
  %2459 = icmp ne i32 %2458, 0, !dbg !1096
  %is_nan622 = and i1 %2457, %2459, !dbg !1096
  %2460 = and i32 %2454, 4194304, !dbg !1096
  %2461 = icmp eq i32 %2460, 0, !dbg !1096
  %is_snan623 = and i1 %is_nan622, %2461, !dbg !1096
  %2462 = or i1 false, %is_snan623, !dbg !1096
  %2463 = bitcast float %2046 to i32, !dbg !1096
  %2464 = and i32 %2463, 2139095040, !dbg !1096
  %2465 = icmp eq i32 %2464, 2139095040, !dbg !1096
  %2466 = and i32 %2463, 8388607, !dbg !1096
  %2467 = icmp eq i32 %2466, 0, !dbg !1096
  %is_inf624 = and i1 %2465, %2467, !dbg !1096
  %2468 = and i1 false, %is_inf624, !dbg !1096
  %2469 = bitcast float %2046 to i32, !dbg !1096
  %2470 = and i32 %2469, 2147483647, !dbg !1096
  %is_zero625 = icmp eq i32 %2470, 0, !dbg !1096
  %2471 = and i1 false, %is_zero625, !dbg !1096
  %2472 = or i1 %2468, %2471, !dbg !1096
  %2473 = or i1 %2462, %2472, !dbg !1096
  br i1 %2473, label %2474, label %2476, !dbg !1096

2474:                                             ; preds = %2453
  %2475 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2476, !dbg !1096

2476:                                             ; preds = %2453, %2474
  %2477 = fmul float 3.000000e+00, %2046, !dbg !1096
  %2478 = bitcast float %2046 to i32, !dbg !1096
  %2479 = and i32 %2478, 2139095040, !dbg !1096
  %is_finite626 = icmp ne i32 %2479, 2139095040, !dbg !1096
  %2480 = and i1 true, %is_finite626, !dbg !1096
  %2481 = bitcast float %2477 to i32, !dbg !1096
  %2482 = and i32 %2481, 2139095040, !dbg !1096
  %2483 = icmp eq i32 %2482, 2139095040, !dbg !1096
  %2484 = and i32 %2481, 8388607, !dbg !1096
  %2485 = icmp eq i32 %2484, 0, !dbg !1096
  %is_inf627 = and i1 %2483, %2485, !dbg !1096
  %2486 = bitcast float %2477 to i32, !dbg !1096
  %2487 = and i32 %2486, 2147483647, !dbg !1096
  %is_maxfinite628 = icmp eq i32 %2487, 2139095039, !dbg !1096
  %2488 = bitcast float %2477 to i32, !dbg !1096
  %2489 = and i32 %2488, -2147483648, !dbg !1096
  %2490 = icmp eq i32 %2489, 0, !dbg !1096
  %2491 = icmp ne i32 %2489, 0, !dbg !1096
  %is_pos_inf629 = and i1 %is_inf627, %2490, !dbg !1096
  %is_neg_inf630 = and i1 %is_inf627, %2491, !dbg !1096
  %is_pos_max631 = and i1 %is_maxfinite628, %2490, !dbg !1096
  %is_neg_max632 = and i1 %is_maxfinite628, %2491, !dbg !1096
  %overflow_cond633 = and i1 %2480, %is_inf627, !dbg !1096
  br i1 %overflow_cond633, label %2492, label %2494, !dbg !1096

2492:                                             ; preds = %2476
  %2493 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2494, !dbg !1096

2494:                                             ; preds = %2476, %2492
  %2495 = bitcast float %2046 to i32, !dbg !1096
  %2496 = and i32 %2495, 2139095040, !dbg !1096
  %2497 = icmp eq i32 %2496, 0, !dbg !1096
  %2498 = and i32 %2495, 8388607, !dbg !1096
  %2499 = icmp ne i32 %2498, 0, !dbg !1096
  %is_subnormal634 = and i1 %2497, %2499, !dbg !1096
  %2500 = xor i1 %is_subnormal634, true, !dbg !1096
  %2501 = and i1 true, %2500, !dbg !1096
  %2502 = bitcast float %2477 to i32, !dbg !1096
  %2503 = and i32 %2502, 2139095040, !dbg !1096
  %2504 = icmp eq i32 %2503, 0, !dbg !1096
  %2505 = and i32 %2502, 8388607, !dbg !1096
  %2506 = icmp ne i32 %2505, 0, !dbg !1096
  %is_subnormal635 = and i1 %2504, %2506, !dbg !1096
  %2507 = bitcast float %2477 to i32, !dbg !1096
  %2508 = and i32 %2507, 2147483647, !dbg !1096
  %is_zero636 = icmp eq i32 %2508, 0, !dbg !1096
  %2509 = bitcast float %2046 to i32, !dbg !1096
  %2510 = and i32 %2509, 2147483647, !dbg !1096
  %is_zero637 = icmp eq i32 %2510, 0, !dbg !1096
  %2511 = xor i1 %is_zero637, true, !dbg !1096
  %2512 = and i1 true, %2511, !dbg !1096
  %2513 = and i1 %is_zero636, %2512, !dbg !1096
  %is_tiny638 = or i1 %is_subnormal635, %2513, !dbg !1096
  %underflow_cond639 = and i1 %2501, %is_tiny638, !dbg !1096
  br i1 %underflow_cond639, label %2514, label %2516, !dbg !1096

2514:                                             ; preds = %2494
  %2515 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2516, !dbg !1096

2516:                                             ; preds = %2494, %2514
  %2517 = bitcast float %2477 to i32, !dbg !1096
  %2518 = bitcast float %2477 to i32, !dbg !1096
  %2519 = and i32 %2518, 2139095040, !dbg !1096
  %2520 = icmp eq i32 %2519, 2139095040, !dbg !1096
  %2521 = and i32 %2518, 8388607, !dbg !1096
  %2522 = icmp ne i32 %2521, 0, !dbg !1096
  %is_nan640 = and i1 %2520, %2522, !dbg !1096
  %2523 = and i32 %2517, 4194304, !dbg !1096
  %2524 = icmp eq i32 %2523, 0, !dbg !1096
  %is_snan641 = and i1 %is_nan640, %2524, !dbg !1096
  %2525 = bitcast float %1731 to i32, !dbg !1096
  %2526 = bitcast float %1731 to i32, !dbg !1096
  %2527 = and i32 %2526, 2139095040, !dbg !1096
  %2528 = icmp eq i32 %2527, 2139095040, !dbg !1096
  %2529 = and i32 %2526, 8388607, !dbg !1096
  %2530 = icmp ne i32 %2529, 0, !dbg !1096
  %is_nan642 = and i1 %2528, %2530, !dbg !1096
  %2531 = and i32 %2525, 4194304, !dbg !1096
  %2532 = icmp eq i32 %2531, 0, !dbg !1096
  %is_snan643 = and i1 %is_nan642, %2532, !dbg !1096
  %2533 = or i1 %is_snan641, %is_snan643, !dbg !1096
  %2534 = bitcast float %2412 to i32, !dbg !1096
  %2535 = bitcast float %2412 to i32, !dbg !1096
  %2536 = and i32 %2535, 2139095040, !dbg !1096
  %2537 = icmp eq i32 %2536, 2139095040, !dbg !1096
  %2538 = and i32 %2535, 8388607, !dbg !1096
  %2539 = icmp ne i32 %2538, 0, !dbg !1096
  %is_nan644 = and i1 %2537, %2539, !dbg !1096
  %2540 = and i32 %2534, 4194304, !dbg !1096
  %2541 = icmp eq i32 %2540, 0, !dbg !1096
  %is_snan645 = and i1 %is_nan644, %2541, !dbg !1096
  %2542 = or i1 %2533, %is_snan645, !dbg !1096
  %2543 = bitcast float %2477 to i32, !dbg !1096
  %2544 = and i32 %2543, 2147483647, !dbg !1096
  %is_zero646 = icmp eq i32 %2544, 0, !dbg !1096
  %2545 = bitcast float %1731 to i32, !dbg !1096
  %2546 = and i32 %2545, 2139095040, !dbg !1096
  %2547 = icmp eq i32 %2546, 2139095040, !dbg !1096
  %2548 = and i32 %2545, 8388607, !dbg !1096
  %2549 = icmp eq i32 %2548, 0, !dbg !1096
  %is_inf647 = and i1 %2547, %2549, !dbg !1096
  %2550 = and i1 %is_zero646, %is_inf647, !dbg !1096
  %2551 = bitcast float %2477 to i32, !dbg !1096
  %2552 = and i32 %2551, 2139095040, !dbg !1096
  %2553 = icmp eq i32 %2552, 2139095040, !dbg !1096
  %2554 = and i32 %2551, 8388607, !dbg !1096
  %2555 = icmp eq i32 %2554, 0, !dbg !1096
  %is_inf648 = and i1 %2553, %2555, !dbg !1096
  %2556 = bitcast float %1731 to i32, !dbg !1096
  %2557 = and i32 %2556, 2147483647, !dbg !1096
  %is_zero649 = icmp eq i32 %2557, 0, !dbg !1096
  %2558 = and i1 %is_inf648, %is_zero649, !dbg !1096
  %2559 = or i1 %2550, %2558, !dbg !1096
  %2560 = or i1 %2542, %2559, !dbg !1096
  br i1 %2560, label %2561, label %2563, !dbg !1096

2561:                                             ; preds = %2516
  %2562 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2563, !dbg !1096

2563:                                             ; preds = %2516, %2561
  %2564 = call float @llvm.nvvm.fma.rn.f(float %2477, float %1731, float %2412) #5, !dbg !1096
  %2565 = bitcast float %2477 to i32, !dbg !1096
  %2566 = and i32 %2565, 2139095040, !dbg !1096
  %is_finite650 = icmp ne i32 %2566, 2139095040, !dbg !1096
  %2567 = and i1 true, %is_finite650, !dbg !1096
  %2568 = bitcast float %1731 to i32, !dbg !1096
  %2569 = and i32 %2568, 2139095040, !dbg !1096
  %is_finite651 = icmp ne i32 %2569, 2139095040, !dbg !1096
  %2570 = and i1 %2567, %is_finite651, !dbg !1096
  %2571 = bitcast float %2564 to i32, !dbg !1096
  %2572 = and i32 %2571, 2139095040, !dbg !1096
  %2573 = icmp eq i32 %2572, 2139095040, !dbg !1096
  %2574 = and i32 %2571, 8388607, !dbg !1096
  %2575 = icmp eq i32 %2574, 0, !dbg !1096
  %is_inf652 = and i1 %2573, %2575, !dbg !1096
  %2576 = bitcast float %2564 to i32, !dbg !1096
  %2577 = and i32 %2576, 2147483647, !dbg !1096
  %is_maxfinite653 = icmp eq i32 %2577, 2139095039, !dbg !1096
  %2578 = bitcast float %2564 to i32, !dbg !1096
  %2579 = and i32 %2578, -2147483648, !dbg !1096
  %2580 = icmp eq i32 %2579, 0, !dbg !1096
  %2581 = icmp ne i32 %2579, 0, !dbg !1096
  %is_pos_inf654 = and i1 %is_inf652, %2580, !dbg !1096
  %is_neg_inf655 = and i1 %is_inf652, %2581, !dbg !1096
  %is_pos_max656 = and i1 %is_maxfinite653, %2580, !dbg !1096
  %is_neg_max657 = and i1 %is_maxfinite653, %2581, !dbg !1096
  %overflow_cond658 = and i1 %2570, %is_inf652, !dbg !1096
  br i1 %overflow_cond658, label %2582, label %2584, !dbg !1096

2582:                                             ; preds = %2563
  %2583 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2584, !dbg !1096

2584:                                             ; preds = %2563, %2582
  %2585 = bitcast float %2477 to i32, !dbg !1096
  %2586 = and i32 %2585, 2139095040, !dbg !1096
  %2587 = icmp eq i32 %2586, 0, !dbg !1096
  %2588 = and i32 %2585, 8388607, !dbg !1096
  %2589 = icmp ne i32 %2588, 0, !dbg !1096
  %is_subnormal659 = and i1 %2587, %2589, !dbg !1096
  %2590 = xor i1 %is_subnormal659, true, !dbg !1096
  %2591 = and i1 true, %2590, !dbg !1096
  %2592 = bitcast float %1731 to i32, !dbg !1096
  %2593 = and i32 %2592, 2139095040, !dbg !1096
  %2594 = icmp eq i32 %2593, 0, !dbg !1096
  %2595 = and i32 %2592, 8388607, !dbg !1096
  %2596 = icmp ne i32 %2595, 0, !dbg !1096
  %is_subnormal660 = and i1 %2594, %2596, !dbg !1096
  %2597 = xor i1 %is_subnormal660, true, !dbg !1096
  %2598 = and i1 %2591, %2597, !dbg !1096
  %2599 = bitcast float %2412 to i32, !dbg !1096
  %2600 = and i32 %2599, 2139095040, !dbg !1096
  %2601 = icmp eq i32 %2600, 0, !dbg !1096
  %2602 = and i32 %2599, 8388607, !dbg !1096
  %2603 = icmp ne i32 %2602, 0, !dbg !1096
  %is_subnormal661 = and i1 %2601, %2603, !dbg !1096
  %2604 = xor i1 %is_subnormal661, true, !dbg !1096
  %2605 = and i1 %2598, %2604, !dbg !1096
  %2606 = bitcast float %2564 to i32, !dbg !1096
  %2607 = and i32 %2606, 2139095040, !dbg !1096
  %2608 = icmp eq i32 %2607, 0, !dbg !1096
  %2609 = and i32 %2606, 8388607, !dbg !1096
  %2610 = icmp ne i32 %2609, 0, !dbg !1096
  %is_subnormal662 = and i1 %2608, %2610, !dbg !1096
  %is_tiny663 = or i1 %is_subnormal662, false, !dbg !1096
  %underflow_cond664 = and i1 %2605, %is_tiny663, !dbg !1096
  br i1 %underflow_cond664, label %2611, label %2613, !dbg !1096

2611:                                             ; preds = %2584
  %2612 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2613, !dbg !1096

2613:                                             ; preds = %2584, %2611
  %2614 = bitcast float %2046 to i32, !dbg !1096
  %2615 = bitcast float %2046 to i32, !dbg !1096
  %2616 = and i32 %2615, 2139095040, !dbg !1096
  %2617 = icmp eq i32 %2616, 2139095040, !dbg !1096
  %2618 = and i32 %2615, 8388607, !dbg !1096
  %2619 = icmp ne i32 %2618, 0, !dbg !1096
  %is_nan665 = and i1 %2617, %2619, !dbg !1096
  %2620 = and i32 %2614, 4194304, !dbg !1096
  %2621 = icmp eq i32 %2620, 0, !dbg !1096
  %is_snan666 = and i1 %is_nan665, %2621, !dbg !1096
  %2622 = bitcast float %1289 to i32, !dbg !1096
  %2623 = bitcast float %1289 to i32, !dbg !1096
  %2624 = and i32 %2623, 2139095040, !dbg !1096
  %2625 = icmp eq i32 %2624, 2139095040, !dbg !1096
  %2626 = and i32 %2623, 8388607, !dbg !1096
  %2627 = icmp ne i32 %2626, 0, !dbg !1096
  %is_nan667 = and i1 %2625, %2627, !dbg !1096
  %2628 = and i32 %2622, 4194304, !dbg !1096
  %2629 = icmp eq i32 %2628, 0, !dbg !1096
  %is_snan668 = and i1 %is_nan667, %2629, !dbg !1096
  %2630 = or i1 %is_snan666, %is_snan668, !dbg !1096
  %2631 = bitcast float %2564 to i32, !dbg !1096
  %2632 = bitcast float %2564 to i32, !dbg !1096
  %2633 = and i32 %2632, 2139095040, !dbg !1096
  %2634 = icmp eq i32 %2633, 2139095040, !dbg !1096
  %2635 = and i32 %2632, 8388607, !dbg !1096
  %2636 = icmp ne i32 %2635, 0, !dbg !1096
  %is_nan669 = and i1 %2634, %2636, !dbg !1096
  %2637 = and i32 %2631, 4194304, !dbg !1096
  %2638 = icmp eq i32 %2637, 0, !dbg !1096
  %is_snan670 = and i1 %is_nan669, %2638, !dbg !1096
  %2639 = or i1 %2630, %is_snan670, !dbg !1096
  %2640 = bitcast float %2046 to i32, !dbg !1096
  %2641 = and i32 %2640, 2147483647, !dbg !1096
  %is_zero671 = icmp eq i32 %2641, 0, !dbg !1096
  %2642 = bitcast float %1289 to i32, !dbg !1096
  %2643 = and i32 %2642, 2139095040, !dbg !1096
  %2644 = icmp eq i32 %2643, 2139095040, !dbg !1096
  %2645 = and i32 %2642, 8388607, !dbg !1096
  %2646 = icmp eq i32 %2645, 0, !dbg !1096
  %is_inf672 = and i1 %2644, %2646, !dbg !1096
  %2647 = and i1 %is_zero671, %is_inf672, !dbg !1096
  %2648 = bitcast float %2046 to i32, !dbg !1096
  %2649 = and i32 %2648, 2139095040, !dbg !1096
  %2650 = icmp eq i32 %2649, 2139095040, !dbg !1096
  %2651 = and i32 %2648, 8388607, !dbg !1096
  %2652 = icmp eq i32 %2651, 0, !dbg !1096
  %is_inf673 = and i1 %2650, %2652, !dbg !1096
  %2653 = bitcast float %1289 to i32, !dbg !1096
  %2654 = and i32 %2653, 2147483647, !dbg !1096
  %is_zero674 = icmp eq i32 %2654, 0, !dbg !1096
  %2655 = and i1 %is_inf673, %is_zero674, !dbg !1096
  %2656 = or i1 %2647, %2655, !dbg !1096
  %2657 = or i1 %2639, %2656, !dbg !1096
  br i1 %2657, label %2658, label %2660, !dbg !1096

2658:                                             ; preds = %2613
  %2659 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2660, !dbg !1096

2660:                                             ; preds = %2613, %2658
  %2661 = call float @llvm.nvvm.fma.rn.f(float %2046, float %1289, float %2564) #5, !dbg !1096
  %2662 = bitcast float %2046 to i32, !dbg !1096
  %2663 = and i32 %2662, 2139095040, !dbg !1096
  %is_finite675 = icmp ne i32 %2663, 2139095040, !dbg !1096
  %2664 = and i1 true, %is_finite675, !dbg !1096
  %2665 = bitcast float %1289 to i32, !dbg !1096
  %2666 = and i32 %2665, 2139095040, !dbg !1096
  %is_finite676 = icmp ne i32 %2666, 2139095040, !dbg !1096
  %2667 = and i1 %2664, %is_finite676, !dbg !1096
  %2668 = bitcast float %2661 to i32, !dbg !1096
  %2669 = and i32 %2668, 2139095040, !dbg !1096
  %2670 = icmp eq i32 %2669, 2139095040, !dbg !1096
  %2671 = and i32 %2668, 8388607, !dbg !1096
  %2672 = icmp eq i32 %2671, 0, !dbg !1096
  %is_inf677 = and i1 %2670, %2672, !dbg !1096
  %2673 = bitcast float %2661 to i32, !dbg !1096
  %2674 = and i32 %2673, 2147483647, !dbg !1096
  %is_maxfinite678 = icmp eq i32 %2674, 2139095039, !dbg !1096
  %2675 = bitcast float %2661 to i32, !dbg !1096
  %2676 = and i32 %2675, -2147483648, !dbg !1096
  %2677 = icmp eq i32 %2676, 0, !dbg !1096
  %2678 = icmp ne i32 %2676, 0, !dbg !1096
  %is_pos_inf679 = and i1 %is_inf677, %2677, !dbg !1096
  %is_neg_inf680 = and i1 %is_inf677, %2678, !dbg !1096
  %is_pos_max681 = and i1 %is_maxfinite678, %2677, !dbg !1096
  %is_neg_max682 = and i1 %is_maxfinite678, %2678, !dbg !1096
  %overflow_cond683 = and i1 %2667, %is_inf677, !dbg !1096
  br i1 %overflow_cond683, label %2679, label %2681, !dbg !1096

2679:                                             ; preds = %2660
  %2680 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2681, !dbg !1096

2681:                                             ; preds = %2660, %2679
  %2682 = bitcast float %2046 to i32, !dbg !1096
  %2683 = and i32 %2682, 2139095040, !dbg !1096
  %2684 = icmp eq i32 %2683, 0, !dbg !1096
  %2685 = and i32 %2682, 8388607, !dbg !1096
  %2686 = icmp ne i32 %2685, 0, !dbg !1096
  %is_subnormal684 = and i1 %2684, %2686, !dbg !1096
  %2687 = xor i1 %is_subnormal684, true, !dbg !1096
  %2688 = and i1 true, %2687, !dbg !1096
  %2689 = bitcast float %1289 to i32, !dbg !1096
  %2690 = and i32 %2689, 2139095040, !dbg !1096
  %2691 = icmp eq i32 %2690, 0, !dbg !1096
  %2692 = and i32 %2689, 8388607, !dbg !1096
  %2693 = icmp ne i32 %2692, 0, !dbg !1096
  %is_subnormal685 = and i1 %2691, %2693, !dbg !1096
  %2694 = xor i1 %is_subnormal685, true, !dbg !1096
  %2695 = and i1 %2688, %2694, !dbg !1096
  %2696 = bitcast float %2564 to i32, !dbg !1096
  %2697 = and i32 %2696, 2139095040, !dbg !1096
  %2698 = icmp eq i32 %2697, 0, !dbg !1096
  %2699 = and i32 %2696, 8388607, !dbg !1096
  %2700 = icmp ne i32 %2699, 0, !dbg !1096
  %is_subnormal686 = and i1 %2698, %2700, !dbg !1096
  %2701 = xor i1 %is_subnormal686, true, !dbg !1096
  %2702 = and i1 %2695, %2701, !dbg !1096
  %2703 = bitcast float %2661 to i32, !dbg !1096
  %2704 = and i32 %2703, 2139095040, !dbg !1096
  %2705 = icmp eq i32 %2704, 0, !dbg !1096
  %2706 = and i32 %2703, 8388607, !dbg !1096
  %2707 = icmp ne i32 %2706, 0, !dbg !1096
  %is_subnormal687 = and i1 %2705, %2707, !dbg !1096
  %is_tiny688 = or i1 %is_subnormal687, false, !dbg !1096
  %underflow_cond689 = and i1 %2702, %is_tiny688, !dbg !1096
  br i1 %underflow_cond689, label %2708, label %2710, !dbg !1096

2708:                                             ; preds = %2681
  %2709 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2710, !dbg !1096

2710:                                             ; preds = %2681, %2708
  %2711 = bitcast float %2131 to i32, !dbg !1096
  %2712 = bitcast float %2131 to i32, !dbg !1096
  %2713 = and i32 %2712, 2139095040, !dbg !1096
  %2714 = icmp eq i32 %2713, 2139095040, !dbg !1096
  %2715 = and i32 %2712, 8388607, !dbg !1096
  %2716 = icmp ne i32 %2715, 0, !dbg !1096
  %is_nan690 = and i1 %2714, %2716, !dbg !1096
  %2717 = and i32 %2711, 4194304, !dbg !1096
  %2718 = icmp eq i32 %2717, 0, !dbg !1096
  %is_snan691 = and i1 %is_nan690, %2718, !dbg !1096
  %2719 = bitcast float %2661 to i32, !dbg !1096
  %2720 = bitcast float %2661 to i32, !dbg !1096
  %2721 = and i32 %2720, 2139095040, !dbg !1096
  %2722 = icmp eq i32 %2721, 2139095040, !dbg !1096
  %2723 = and i32 %2720, 8388607, !dbg !1096
  %2724 = icmp ne i32 %2723, 0, !dbg !1096
  %is_nan692 = and i1 %2722, %2724, !dbg !1096
  %2725 = and i32 %2719, 4194304, !dbg !1096
  %2726 = icmp eq i32 %2725, 0, !dbg !1096
  %is_snan693 = and i1 %is_nan692, %2726, !dbg !1096
  %2727 = or i1 %is_snan691, %is_snan693, !dbg !1096
  %2728 = bitcast float %2131 to i32, !dbg !1096
  %2729 = and i32 %2728, 2139095040, !dbg !1096
  %2730 = icmp eq i32 %2729, 2139095040, !dbg !1096
  %2731 = and i32 %2728, 8388607, !dbg !1096
  %2732 = icmp eq i32 %2731, 0, !dbg !1096
  %is_inf694 = and i1 %2730, %2732, !dbg !1096
  %2733 = bitcast float %2661 to i32, !dbg !1096
  %2734 = and i32 %2733, 2139095040, !dbg !1096
  %2735 = icmp eq i32 %2734, 2139095040, !dbg !1096
  %2736 = and i32 %2733, 8388607, !dbg !1096
  %2737 = icmp eq i32 %2736, 0, !dbg !1096
  %is_inf695 = and i1 %2735, %2737, !dbg !1096
  %2738 = and i1 %is_inf694, %is_inf695, !dbg !1096
  %2739 = bitcast float %2131 to i32, !dbg !1096
  %2740 = bitcast float %2661 to i32, !dbg !1096
  %2741 = and i32 %2739, -2147483648, !dbg !1096
  %2742 = and i32 %2740, -2147483648, !dbg !1096
  %2743 = icmp ne i32 %2741, %2742, !dbg !1096
  %2744 = and i1 %2738, %2743, !dbg !1096
  %2745 = or i1 %2727, %2744, !dbg !1096
  br i1 %2745, label %2746, label %2748, !dbg !1096

2746:                                             ; preds = %2710
  %2747 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2748, !dbg !1096

2748:                                             ; preds = %2710, %2746
  %2749 = call float @llvm.nvvm.add.rn.f(float %2131, float %2661) #5, !dbg !1096
  %2750 = bitcast float %2131 to i32, !dbg !1096
  %2751 = and i32 %2750, 2139095040, !dbg !1096
  %is_finite696 = icmp ne i32 %2751, 2139095040, !dbg !1096
  %2752 = and i1 true, %is_finite696, !dbg !1096
  %2753 = bitcast float %2661 to i32, !dbg !1096
  %2754 = and i32 %2753, 2139095040, !dbg !1096
  %is_finite697 = icmp ne i32 %2754, 2139095040, !dbg !1096
  %2755 = and i1 %2752, %is_finite697, !dbg !1096
  %2756 = bitcast float %2749 to i32, !dbg !1096
  %2757 = and i32 %2756, 2139095040, !dbg !1096
  %2758 = icmp eq i32 %2757, 2139095040, !dbg !1096
  %2759 = and i32 %2756, 8388607, !dbg !1096
  %2760 = icmp eq i32 %2759, 0, !dbg !1096
  %is_inf698 = and i1 %2758, %2760, !dbg !1096
  %2761 = bitcast float %2749 to i32, !dbg !1096
  %2762 = and i32 %2761, 2147483647, !dbg !1096
  %is_maxfinite699 = icmp eq i32 %2762, 2139095039, !dbg !1096
  %2763 = bitcast float %2749 to i32, !dbg !1096
  %2764 = and i32 %2763, -2147483648, !dbg !1096
  %2765 = icmp eq i32 %2764, 0, !dbg !1096
  %2766 = icmp ne i32 %2764, 0, !dbg !1096
  %is_pos_inf700 = and i1 %is_inf698, %2765, !dbg !1096
  %is_neg_inf701 = and i1 %is_inf698, %2766, !dbg !1096
  %is_pos_max702 = and i1 %is_maxfinite699, %2765, !dbg !1096
  %is_neg_max703 = and i1 %is_maxfinite699, %2766, !dbg !1096
  %overflow_cond704 = and i1 %2755, %is_inf698, !dbg !1096
  br i1 %overflow_cond704, label %2767, label %2769, !dbg !1096

2767:                                             ; preds = %2748
  %2768 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2769, !dbg !1096

2769:                                             ; preds = %2748, %2767
  %2770 = bitcast float %2131 to i32, !dbg !1096
  %2771 = bitcast float %2131 to i32, !dbg !1096
  %2772 = and i32 %2771, 2139095040, !dbg !1096
  %2773 = icmp eq i32 %2772, 2139095040, !dbg !1096
  %2774 = and i32 %2771, 8388607, !dbg !1096
  %2775 = icmp ne i32 %2774, 0, !dbg !1096
  %is_nan705 = and i1 %2773, %2775, !dbg !1096
  %2776 = and i32 %2770, 4194304, !dbg !1096
  %2777 = icmp eq i32 %2776, 0, !dbg !1096
  %is_snan706 = and i1 %is_nan705, %2777, !dbg !1096
  %2778 = or i1 false, %is_snan706, !dbg !1096
  %2779 = bitcast float %2131 to i32, !dbg !1096
  %2780 = and i32 %2779, 2139095040, !dbg !1096
  %2781 = icmp eq i32 %2780, 2139095040, !dbg !1096
  %2782 = and i32 %2779, 8388607, !dbg !1096
  %2783 = icmp eq i32 %2782, 0, !dbg !1096
  %is_inf707 = and i1 %2781, %2783, !dbg !1096
  %2784 = and i1 false, %is_inf707, !dbg !1096
  %2785 = bitcast float %2131 to i32, !dbg !1096
  %2786 = and i32 %2785, -2147483648, !dbg !1096
  %2787 = icmp eq i32 -2147483648, %2786, !dbg !1096
  %2788 = and i1 %2784, %2787, !dbg !1096
  %2789 = or i1 %2778, %2788, !dbg !1096
  br i1 %2789, label %2790, label %2792, !dbg !1096

2790:                                             ; preds = %2769
  %2791 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2792, !dbg !1096

2792:                                             ; preds = %2769, %2790
  %2793 = fsub float -0.000000e+00, %2131, !dbg !1096
  %2794 = bitcast float %2131 to i32, !dbg !1096
  %2795 = and i32 %2794, 2139095040, !dbg !1096
  %is_finite708 = icmp ne i32 %2795, 2139095040, !dbg !1096
  %2796 = and i1 true, %is_finite708, !dbg !1096
  %2797 = bitcast float %2793 to i32, !dbg !1096
  %2798 = and i32 %2797, 2139095040, !dbg !1096
  %2799 = icmp eq i32 %2798, 2139095040, !dbg !1096
  %2800 = and i32 %2797, 8388607, !dbg !1096
  %2801 = icmp eq i32 %2800, 0, !dbg !1096
  %is_inf709 = and i1 %2799, %2801, !dbg !1096
  %2802 = bitcast float %2793 to i32, !dbg !1096
  %2803 = and i32 %2802, 2147483647, !dbg !1096
  %is_maxfinite710 = icmp eq i32 %2803, 2139095039, !dbg !1096
  %2804 = bitcast float %2793 to i32, !dbg !1096
  %2805 = and i32 %2804, -2147483648, !dbg !1096
  %2806 = icmp eq i32 %2805, 0, !dbg !1096
  %2807 = icmp ne i32 %2805, 0, !dbg !1096
  %is_pos_inf711 = and i1 %is_inf709, %2806, !dbg !1096
  %is_neg_inf712 = and i1 %is_inf709, %2807, !dbg !1096
  %is_pos_max713 = and i1 %is_maxfinite710, %2806, !dbg !1096
  %is_neg_max714 = and i1 %is_maxfinite710, %2807, !dbg !1096
  %overflow_cond715 = and i1 %2796, %is_inf709, !dbg !1096
  br i1 %overflow_cond715, label %2808, label %2810, !dbg !1096

2808:                                             ; preds = %2792
  %2809 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2810, !dbg !1096

2810:                                             ; preds = %2792, %2808
  %2811 = bitcast float %2749 to i32, !dbg !1096
  %2812 = bitcast float %2749 to i32, !dbg !1096
  %2813 = and i32 %2812, 2139095040, !dbg !1096
  %2814 = icmp eq i32 %2813, 2139095040, !dbg !1096
  %2815 = and i32 %2812, 8388607, !dbg !1096
  %2816 = icmp ne i32 %2815, 0, !dbg !1096
  %is_nan716 = and i1 %2814, %2816, !dbg !1096
  %2817 = and i32 %2811, 4194304, !dbg !1096
  %2818 = icmp eq i32 %2817, 0, !dbg !1096
  %is_snan717 = and i1 %is_nan716, %2818, !dbg !1096
  %2819 = bitcast float %2793 to i32, !dbg !1096
  %2820 = bitcast float %2793 to i32, !dbg !1096
  %2821 = and i32 %2820, 2139095040, !dbg !1096
  %2822 = icmp eq i32 %2821, 2139095040, !dbg !1096
  %2823 = and i32 %2820, 8388607, !dbg !1096
  %2824 = icmp ne i32 %2823, 0, !dbg !1096
  %is_nan718 = and i1 %2822, %2824, !dbg !1096
  %2825 = and i32 %2819, 4194304, !dbg !1096
  %2826 = icmp eq i32 %2825, 0, !dbg !1096
  %is_snan719 = and i1 %is_nan718, %2826, !dbg !1096
  %2827 = or i1 %is_snan717, %is_snan719, !dbg !1096
  %2828 = bitcast float %2749 to i32, !dbg !1096
  %2829 = and i32 %2828, 2139095040, !dbg !1096
  %2830 = icmp eq i32 %2829, 2139095040, !dbg !1096
  %2831 = and i32 %2828, 8388607, !dbg !1096
  %2832 = icmp eq i32 %2831, 0, !dbg !1096
  %is_inf720 = and i1 %2830, %2832, !dbg !1096
  %2833 = bitcast float %2793 to i32, !dbg !1096
  %2834 = and i32 %2833, 2139095040, !dbg !1096
  %2835 = icmp eq i32 %2834, 2139095040, !dbg !1096
  %2836 = and i32 %2833, 8388607, !dbg !1096
  %2837 = icmp eq i32 %2836, 0, !dbg !1096
  %is_inf721 = and i1 %2835, %2837, !dbg !1096
  %2838 = and i1 %is_inf720, %is_inf721, !dbg !1096
  %2839 = bitcast float %2749 to i32, !dbg !1096
  %2840 = bitcast float %2793 to i32, !dbg !1096
  %2841 = and i32 %2839, -2147483648, !dbg !1096
  %2842 = and i32 %2840, -2147483648, !dbg !1096
  %2843 = icmp ne i32 %2841, %2842, !dbg !1096
  %2844 = and i1 %2838, %2843, !dbg !1096
  %2845 = or i1 %2827, %2844, !dbg !1096
  br i1 %2845, label %2846, label %2848, !dbg !1096

2846:                                             ; preds = %2810
  %2847 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2848, !dbg !1096

2848:                                             ; preds = %2810, %2846
  %2849 = call float @llvm.nvvm.add.rn.f(float %2749, float %2793) #5, !dbg !1096
  %2850 = bitcast float %2749 to i32, !dbg !1096
  %2851 = and i32 %2850, 2139095040, !dbg !1096
  %is_finite722 = icmp ne i32 %2851, 2139095040, !dbg !1096
  %2852 = and i1 true, %is_finite722, !dbg !1096
  %2853 = bitcast float %2793 to i32, !dbg !1096
  %2854 = and i32 %2853, 2139095040, !dbg !1096
  %is_finite723 = icmp ne i32 %2854, 2139095040, !dbg !1096
  %2855 = and i1 %2852, %is_finite723, !dbg !1096
  %2856 = bitcast float %2849 to i32, !dbg !1096
  %2857 = and i32 %2856, 2139095040, !dbg !1096
  %2858 = icmp eq i32 %2857, 2139095040, !dbg !1096
  %2859 = and i32 %2856, 8388607, !dbg !1096
  %2860 = icmp eq i32 %2859, 0, !dbg !1096
  %is_inf724 = and i1 %2858, %2860, !dbg !1096
  %2861 = bitcast float %2849 to i32, !dbg !1096
  %2862 = and i32 %2861, 2147483647, !dbg !1096
  %is_maxfinite725 = icmp eq i32 %2862, 2139095039, !dbg !1096
  %2863 = bitcast float %2849 to i32, !dbg !1096
  %2864 = and i32 %2863, -2147483648, !dbg !1096
  %2865 = icmp eq i32 %2864, 0, !dbg !1096
  %2866 = icmp ne i32 %2864, 0, !dbg !1096
  %is_pos_inf726 = and i1 %is_inf724, %2865, !dbg !1096
  %is_neg_inf727 = and i1 %is_inf724, %2866, !dbg !1096
  %is_pos_max728 = and i1 %is_maxfinite725, %2865, !dbg !1096
  %is_neg_max729 = and i1 %is_maxfinite725, %2866, !dbg !1096
  %overflow_cond730 = and i1 %2855, %is_inf724, !dbg !1096
  br i1 %overflow_cond730, label %2867, label %2869, !dbg !1096

2867:                                             ; preds = %2848
  %2868 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2869, !dbg !1096

2869:                                             ; preds = %2848, %2867
  %2870 = bitcast float %2849 to i32, !dbg !1096
  %2871 = bitcast float %2849 to i32, !dbg !1096
  %2872 = and i32 %2871, 2139095040, !dbg !1096
  %2873 = icmp eq i32 %2872, 2139095040, !dbg !1096
  %2874 = and i32 %2871, 8388607, !dbg !1096
  %2875 = icmp ne i32 %2874, 0, !dbg !1096
  %is_nan731 = and i1 %2873, %2875, !dbg !1096
  %2876 = and i32 %2870, 4194304, !dbg !1096
  %2877 = icmp eq i32 %2876, 0, !dbg !1096
  %is_snan732 = and i1 %is_nan731, %2877, !dbg !1096
  %2878 = or i1 false, %is_snan732, !dbg !1096
  %2879 = bitcast float %2849 to i32, !dbg !1096
  %2880 = and i32 %2879, 2139095040, !dbg !1096
  %2881 = icmp eq i32 %2880, 2139095040, !dbg !1096
  %2882 = and i32 %2879, 8388607, !dbg !1096
  %2883 = icmp eq i32 %2882, 0, !dbg !1096
  %is_inf733 = and i1 %2881, %2883, !dbg !1096
  %2884 = and i1 false, %is_inf733, !dbg !1096
  %2885 = bitcast float %2849 to i32, !dbg !1096
  %2886 = and i32 %2885, -2147483648, !dbg !1096
  %2887 = icmp eq i32 -2147483648, %2886, !dbg !1096
  %2888 = and i1 %2884, %2887, !dbg !1096
  %2889 = or i1 %2878, %2888, !dbg !1096
  br i1 %2889, label %2890, label %2892, !dbg !1096

2890:                                             ; preds = %2869
  %2891 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2892, !dbg !1096

2892:                                             ; preds = %2869, %2890
  %2893 = fsub float -0.000000e+00, %2849, !dbg !1096
  %2894 = bitcast float %2849 to i32, !dbg !1096
  %2895 = and i32 %2894, 2139095040, !dbg !1096
  %is_finite734 = icmp ne i32 %2895, 2139095040, !dbg !1096
  %2896 = and i1 true, %is_finite734, !dbg !1096
  %2897 = bitcast float %2893 to i32, !dbg !1096
  %2898 = and i32 %2897, 2139095040, !dbg !1096
  %2899 = icmp eq i32 %2898, 2139095040, !dbg !1096
  %2900 = and i32 %2897, 8388607, !dbg !1096
  %2901 = icmp eq i32 %2900, 0, !dbg !1096
  %is_inf735 = and i1 %2899, %2901, !dbg !1096
  %2902 = bitcast float %2893 to i32, !dbg !1096
  %2903 = and i32 %2902, 2147483647, !dbg !1096
  %is_maxfinite736 = icmp eq i32 %2903, 2139095039, !dbg !1096
  %2904 = bitcast float %2893 to i32, !dbg !1096
  %2905 = and i32 %2904, -2147483648, !dbg !1096
  %2906 = icmp eq i32 %2905, 0, !dbg !1096
  %2907 = icmp ne i32 %2905, 0, !dbg !1096
  %is_pos_inf737 = and i1 %is_inf735, %2906, !dbg !1096
  %is_neg_inf738 = and i1 %is_inf735, %2907, !dbg !1096
  %is_pos_max739 = and i1 %is_maxfinite736, %2906, !dbg !1096
  %is_neg_max740 = and i1 %is_maxfinite736, %2907, !dbg !1096
  %overflow_cond741 = and i1 %2896, %is_inf735, !dbg !1096
  br i1 %overflow_cond741, label %2908, label %2910, !dbg !1096

2908:                                             ; preds = %2892
  %2909 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2910, !dbg !1096

2910:                                             ; preds = %2892, %2908
  %2911 = bitcast float %2661 to i32, !dbg !1096
  %2912 = bitcast float %2661 to i32, !dbg !1096
  %2913 = and i32 %2912, 2139095040, !dbg !1096
  %2914 = icmp eq i32 %2913, 2139095040, !dbg !1096
  %2915 = and i32 %2912, 8388607, !dbg !1096
  %2916 = icmp ne i32 %2915, 0, !dbg !1096
  %is_nan742 = and i1 %2914, %2916, !dbg !1096
  %2917 = and i32 %2911, 4194304, !dbg !1096
  %2918 = icmp eq i32 %2917, 0, !dbg !1096
  %is_snan743 = and i1 %is_nan742, %2918, !dbg !1096
  %2919 = bitcast float %2893 to i32, !dbg !1096
  %2920 = bitcast float %2893 to i32, !dbg !1096
  %2921 = and i32 %2920, 2139095040, !dbg !1096
  %2922 = icmp eq i32 %2921, 2139095040, !dbg !1096
  %2923 = and i32 %2920, 8388607, !dbg !1096
  %2924 = icmp ne i32 %2923, 0, !dbg !1096
  %is_nan744 = and i1 %2922, %2924, !dbg !1096
  %2925 = and i32 %2919, 4194304, !dbg !1096
  %2926 = icmp eq i32 %2925, 0, !dbg !1096
  %is_snan745 = and i1 %is_nan744, %2926, !dbg !1096
  %2927 = or i1 %is_snan743, %is_snan745, !dbg !1096
  %2928 = bitcast float %2661 to i32, !dbg !1096
  %2929 = and i32 %2928, 2139095040, !dbg !1096
  %2930 = icmp eq i32 %2929, 2139095040, !dbg !1096
  %2931 = and i32 %2928, 8388607, !dbg !1096
  %2932 = icmp eq i32 %2931, 0, !dbg !1096
  %is_inf746 = and i1 %2930, %2932, !dbg !1096
  %2933 = bitcast float %2893 to i32, !dbg !1096
  %2934 = and i32 %2933, 2139095040, !dbg !1096
  %2935 = icmp eq i32 %2934, 2139095040, !dbg !1096
  %2936 = and i32 %2933, 8388607, !dbg !1096
  %2937 = icmp eq i32 %2936, 0, !dbg !1096
  %is_inf747 = and i1 %2935, %2937, !dbg !1096
  %2938 = and i1 %is_inf746, %is_inf747, !dbg !1096
  %2939 = bitcast float %2661 to i32, !dbg !1096
  %2940 = bitcast float %2893 to i32, !dbg !1096
  %2941 = and i32 %2939, -2147483648, !dbg !1096
  %2942 = and i32 %2940, -2147483648, !dbg !1096
  %2943 = icmp ne i32 %2941, %2942, !dbg !1096
  %2944 = and i1 %2938, %2943, !dbg !1096
  %2945 = or i1 %2927, %2944, !dbg !1096
  br i1 %2945, label %2946, label %2948, !dbg !1096

2946:                                             ; preds = %2910
  %2947 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2948, !dbg !1096

2948:                                             ; preds = %2910, %2946
  %2949 = call float @llvm.nvvm.add.rn.f(float %2661, float %2893) #5, !dbg !1096
  %2950 = bitcast float %2661 to i32, !dbg !1096
  %2951 = and i32 %2950, 2139095040, !dbg !1096
  %is_finite748 = icmp ne i32 %2951, 2139095040, !dbg !1096
  %2952 = and i1 true, %is_finite748, !dbg !1096
  %2953 = bitcast float %2893 to i32, !dbg !1096
  %2954 = and i32 %2953, 2139095040, !dbg !1096
  %is_finite749 = icmp ne i32 %2954, 2139095040, !dbg !1096
  %2955 = and i1 %2952, %is_finite749, !dbg !1096
  %2956 = bitcast float %2949 to i32, !dbg !1096
  %2957 = and i32 %2956, 2139095040, !dbg !1096
  %2958 = icmp eq i32 %2957, 2139095040, !dbg !1096
  %2959 = and i32 %2956, 8388607, !dbg !1096
  %2960 = icmp eq i32 %2959, 0, !dbg !1096
  %is_inf750 = and i1 %2958, %2960, !dbg !1096
  %2961 = bitcast float %2949 to i32, !dbg !1096
  %2962 = and i32 %2961, 2147483647, !dbg !1096
  %is_maxfinite751 = icmp eq i32 %2962, 2139095039, !dbg !1096
  %2963 = bitcast float %2949 to i32, !dbg !1096
  %2964 = and i32 %2963, -2147483648, !dbg !1096
  %2965 = icmp eq i32 %2964, 0, !dbg !1096
  %2966 = icmp ne i32 %2964, 0, !dbg !1096
  %is_pos_inf752 = and i1 %is_inf750, %2965, !dbg !1096
  %is_neg_inf753 = and i1 %is_inf750, %2966, !dbg !1096
  %is_pos_max754 = and i1 %is_maxfinite751, %2965, !dbg !1096
  %is_neg_max755 = and i1 %is_maxfinite751, %2966, !dbg !1096
  %overflow_cond756 = and i1 %2955, %is_inf750, !dbg !1096
  br i1 %overflow_cond756, label %2967, label %2969, !dbg !1096

2967:                                             ; preds = %2948
  %2968 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %2969, !dbg !1096

2969:                                             ; preds = %2948, %2967
  %insert77.i = insertvalue %struct.float2 undef, float %2749, 0, !dbg !1096
  %insert79.i = insertvalue %struct.float2 %insert77.i, float %2949, 1, !dbg !1096
  %insert.i = insertvalue %struct.float2 undef, float %2749, 0, !dbg !1096
  %insert69.i = insertvalue %struct.float2 %insert.i, float %2949, 1, !dbg !1096
  %2970 = bitcast float %2749 to i32, !dbg !1096
  %2971 = bitcast float %2749 to i32, !dbg !1096
  %2972 = and i32 %2971, 2139095040, !dbg !1096
  %2973 = icmp eq i32 %2972, 2139095040, !dbg !1096
  %2974 = and i32 %2971, 8388607, !dbg !1096
  %2975 = icmp ne i32 %2974, 0, !dbg !1096
  %is_nan757 = and i1 %2973, %2975, !dbg !1096
  %2976 = and i32 %2970, 4194304, !dbg !1096
  %2977 = icmp eq i32 %2976, 0, !dbg !1096
  %is_snan758 = and i1 %is_nan757, %2977, !dbg !1096
  %2978 = bitcast float %763 to i32, !dbg !1096
  %2979 = bitcast float %763 to i32, !dbg !1096
  %2980 = and i32 %2979, 2139095040, !dbg !1096
  %2981 = icmp eq i32 %2980, 2139095040, !dbg !1096
  %2982 = and i32 %2979, 8388607, !dbg !1096
  %2983 = icmp ne i32 %2982, 0, !dbg !1096
  %is_nan759 = and i1 %2981, %2983, !dbg !1096
  %2984 = and i32 %2978, 4194304, !dbg !1096
  %2985 = icmp eq i32 %2984, 0, !dbg !1096
  %is_snan760 = and i1 %is_nan759, %2985, !dbg !1096
  %2986 = or i1 %is_snan758, %is_snan760, !dbg !1096
  %2987 = bitcast float %2749 to i32, !dbg !1096
  %2988 = and i32 %2987, 2147483647, !dbg !1096
  %is_zero761 = icmp eq i32 %2988, 0, !dbg !1096
  %2989 = bitcast float %763 to i32, !dbg !1096
  %2990 = and i32 %2989, 2139095040, !dbg !1096
  %2991 = icmp eq i32 %2990, 2139095040, !dbg !1096
  %2992 = and i32 %2989, 8388607, !dbg !1096
  %2993 = icmp eq i32 %2992, 0, !dbg !1096
  %is_inf762 = and i1 %2991, %2993, !dbg !1096
  %2994 = and i1 %is_zero761, %is_inf762, !dbg !1096
  %2995 = bitcast float %2749 to i32, !dbg !1096
  %2996 = and i32 %2995, 2139095040, !dbg !1096
  %2997 = icmp eq i32 %2996, 2139095040, !dbg !1096
  %2998 = and i32 %2995, 8388607, !dbg !1096
  %2999 = icmp eq i32 %2998, 0, !dbg !1096
  %is_inf763 = and i1 %2997, %2999, !dbg !1096
  %3000 = bitcast float %763 to i32, !dbg !1096
  %3001 = and i32 %3000, 2147483647, !dbg !1096
  %is_zero764 = icmp eq i32 %3001, 0, !dbg !1096
  %3002 = and i1 %is_inf763, %is_zero764, !dbg !1096
  %3003 = or i1 %2994, %3002, !dbg !1096
  %3004 = or i1 %2986, %3003, !dbg !1096
  br i1 %3004, label %3005, label %3007, !dbg !1096

3005:                                             ; preds = %2969
  %3006 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3007, !dbg !1096

3007:                                             ; preds = %2969, %3005
  %3008 = call float @llvm.nvvm.mul.rn.f(float %2749, float %763) #5, !dbg !1096
  %3009 = bitcast float %2749 to i32, !dbg !1096
  %3010 = and i32 %3009, 2139095040, !dbg !1096
  %is_finite765 = icmp ne i32 %3010, 2139095040, !dbg !1096
  %3011 = and i1 true, %is_finite765, !dbg !1096
  %3012 = bitcast float %763 to i32, !dbg !1096
  %3013 = and i32 %3012, 2139095040, !dbg !1096
  %is_finite766 = icmp ne i32 %3013, 2139095040, !dbg !1096
  %3014 = and i1 %3011, %is_finite766, !dbg !1096
  %3015 = bitcast float %3008 to i32, !dbg !1096
  %3016 = and i32 %3015, 2139095040, !dbg !1096
  %3017 = icmp eq i32 %3016, 2139095040, !dbg !1096
  %3018 = and i32 %3015, 8388607, !dbg !1096
  %3019 = icmp eq i32 %3018, 0, !dbg !1096
  %is_inf767 = and i1 %3017, %3019, !dbg !1096
  %3020 = bitcast float %3008 to i32, !dbg !1096
  %3021 = and i32 %3020, 2147483647, !dbg !1096
  %is_maxfinite768 = icmp eq i32 %3021, 2139095039, !dbg !1096
  %3022 = bitcast float %3008 to i32, !dbg !1096
  %3023 = and i32 %3022, -2147483648, !dbg !1096
  %3024 = icmp eq i32 %3023, 0, !dbg !1096
  %3025 = icmp ne i32 %3023, 0, !dbg !1096
  %is_pos_inf769 = and i1 %is_inf767, %3024, !dbg !1096
  %is_neg_inf770 = and i1 %is_inf767, %3025, !dbg !1096
  %is_pos_max771 = and i1 %is_maxfinite768, %3024, !dbg !1096
  %is_neg_max772 = and i1 %is_maxfinite768, %3025, !dbg !1096
  %overflow_cond773 = and i1 %3014, %is_inf767, !dbg !1096
  br i1 %overflow_cond773, label %3026, label %3028, !dbg !1096

3026:                                             ; preds = %3007
  %3027 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3028, !dbg !1096

3028:                                             ; preds = %3007, %3026
  %3029 = bitcast float %2749 to i32, !dbg !1096
  %3030 = and i32 %3029, 2139095040, !dbg !1096
  %3031 = icmp eq i32 %3030, 0, !dbg !1096
  %3032 = and i32 %3029, 8388607, !dbg !1096
  %3033 = icmp ne i32 %3032, 0, !dbg !1096
  %is_subnormal774 = and i1 %3031, %3033, !dbg !1096
  %3034 = xor i1 %is_subnormal774, true, !dbg !1096
  %3035 = and i1 true, %3034, !dbg !1096
  %3036 = bitcast float %763 to i32, !dbg !1096
  %3037 = and i32 %3036, 2139095040, !dbg !1096
  %3038 = icmp eq i32 %3037, 0, !dbg !1096
  %3039 = and i32 %3036, 8388607, !dbg !1096
  %3040 = icmp ne i32 %3039, 0, !dbg !1096
  %is_subnormal775 = and i1 %3038, %3040, !dbg !1096
  %3041 = xor i1 %is_subnormal775, true, !dbg !1096
  %3042 = and i1 %3035, %3041, !dbg !1096
  %3043 = bitcast float %3008 to i32, !dbg !1096
  %3044 = and i32 %3043, 2139095040, !dbg !1096
  %3045 = icmp eq i32 %3044, 0, !dbg !1096
  %3046 = and i32 %3043, 8388607, !dbg !1096
  %3047 = icmp ne i32 %3046, 0, !dbg !1096
  %is_subnormal776 = and i1 %3045, %3047, !dbg !1096
  %3048 = bitcast float %3008 to i32, !dbg !1096
  %3049 = and i32 %3048, 2147483647, !dbg !1096
  %is_zero777 = icmp eq i32 %3049, 0, !dbg !1096
  %3050 = bitcast float %2749 to i32, !dbg !1096
  %3051 = and i32 %3050, 2147483647, !dbg !1096
  %is_zero778 = icmp eq i32 %3051, 0, !dbg !1096
  %3052 = xor i1 %is_zero778, true, !dbg !1096
  %3053 = bitcast float %763 to i32, !dbg !1096
  %3054 = and i32 %3053, 2147483647, !dbg !1096
  %is_zero779 = icmp eq i32 %3054, 0, !dbg !1096
  %3055 = xor i1 %is_zero779, true, !dbg !1096
  %3056 = and i1 %3052, %3055, !dbg !1096
  %3057 = and i1 %is_zero777, %3056, !dbg !1096
  %is_tiny780 = or i1 %is_subnormal776, %3057, !dbg !1096
  %underflow_cond781 = and i1 %3042, %is_tiny780, !dbg !1096
  br i1 %underflow_cond781, label %3058, label %3060, !dbg !1096

3058:                                             ; preds = %3028
  %3059 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3060, !dbg !1096

3060:                                             ; preds = %3028, %3058
  %3061 = bitcast float %3008 to i32, !dbg !1096
  %3062 = bitcast float %3008 to i32, !dbg !1096
  %3063 = and i32 %3062, 2139095040, !dbg !1096
  %3064 = icmp eq i32 %3063, 2139095040, !dbg !1096
  %3065 = and i32 %3062, 8388607, !dbg !1096
  %3066 = icmp ne i32 %3065, 0, !dbg !1096
  %is_nan782 = and i1 %3064, %3066, !dbg !1096
  %3067 = and i32 %3061, 4194304, !dbg !1096
  %3068 = icmp eq i32 %3067, 0, !dbg !1096
  %is_snan783 = and i1 %is_nan782, %3068, !dbg !1096
  %3069 = or i1 false, %is_snan783, !dbg !1096
  %3070 = bitcast float %3008 to i32, !dbg !1096
  %3071 = and i32 %3070, 2139095040, !dbg !1096
  %3072 = icmp eq i32 %3071, 2139095040, !dbg !1096
  %3073 = and i32 %3070, 8388607, !dbg !1096
  %3074 = icmp eq i32 %3073, 0, !dbg !1096
  %is_inf784 = and i1 %3072, %3074, !dbg !1096
  %3075 = and i1 false, %is_inf784, !dbg !1096
  %3076 = bitcast float %3008 to i32, !dbg !1096
  %3077 = and i32 %3076, -2147483648, !dbg !1096
  %3078 = icmp eq i32 -2147483648, %3077, !dbg !1096
  %3079 = and i1 %3075, %3078, !dbg !1096
  %3080 = or i1 %3069, %3079, !dbg !1096
  br i1 %3080, label %3081, label %3083, !dbg !1096

3081:                                             ; preds = %3060
  %3082 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3083, !dbg !1096

3083:                                             ; preds = %3060, %3081
  %3084 = fsub float -0.000000e+00, %3008, !dbg !1096
  %3085 = bitcast float %3008 to i32, !dbg !1096
  %3086 = and i32 %3085, 2139095040, !dbg !1096
  %is_finite785 = icmp ne i32 %3086, 2139095040, !dbg !1096
  %3087 = and i1 true, %is_finite785, !dbg !1096
  %3088 = bitcast float %3084 to i32, !dbg !1096
  %3089 = and i32 %3088, 2139095040, !dbg !1096
  %3090 = icmp eq i32 %3089, 2139095040, !dbg !1096
  %3091 = and i32 %3088, 8388607, !dbg !1096
  %3092 = icmp eq i32 %3091, 0, !dbg !1096
  %is_inf786 = and i1 %3090, %3092, !dbg !1096
  %3093 = bitcast float %3084 to i32, !dbg !1096
  %3094 = and i32 %3093, 2147483647, !dbg !1096
  %is_maxfinite787 = icmp eq i32 %3094, 2139095039, !dbg !1096
  %3095 = bitcast float %3084 to i32, !dbg !1096
  %3096 = and i32 %3095, -2147483648, !dbg !1096
  %3097 = icmp eq i32 %3096, 0, !dbg !1096
  %3098 = icmp ne i32 %3096, 0, !dbg !1096
  %is_pos_inf788 = and i1 %is_inf786, %3097, !dbg !1096
  %is_neg_inf789 = and i1 %is_inf786, %3098, !dbg !1096
  %is_pos_max790 = and i1 %is_maxfinite787, %3097, !dbg !1096
  %is_neg_max791 = and i1 %is_maxfinite787, %3098, !dbg !1096
  %overflow_cond792 = and i1 %3087, %is_inf786, !dbg !1096
  br i1 %overflow_cond792, label %3099, label %3101, !dbg !1096

3099:                                             ; preds = %3083
  %3100 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3101, !dbg !1096

3101:                                             ; preds = %3083, %3099
  %3102 = bitcast float %2749 to i32, !dbg !1096
  %3103 = bitcast float %2749 to i32, !dbg !1096
  %3104 = and i32 %3103, 2139095040, !dbg !1096
  %3105 = icmp eq i32 %3104, 2139095040, !dbg !1096
  %3106 = and i32 %3103, 8388607, !dbg !1096
  %3107 = icmp ne i32 %3106, 0, !dbg !1096
  %is_nan793 = and i1 %3105, %3107, !dbg !1096
  %3108 = and i32 %3102, 4194304, !dbg !1096
  %3109 = icmp eq i32 %3108, 0, !dbg !1096
  %is_snan794 = and i1 %is_nan793, %3109, !dbg !1096
  %3110 = bitcast float %763 to i32, !dbg !1096
  %3111 = bitcast float %763 to i32, !dbg !1096
  %3112 = and i32 %3111, 2139095040, !dbg !1096
  %3113 = icmp eq i32 %3112, 2139095040, !dbg !1096
  %3114 = and i32 %3111, 8388607, !dbg !1096
  %3115 = icmp ne i32 %3114, 0, !dbg !1096
  %is_nan795 = and i1 %3113, %3115, !dbg !1096
  %3116 = and i32 %3110, 4194304, !dbg !1096
  %3117 = icmp eq i32 %3116, 0, !dbg !1096
  %is_snan796 = and i1 %is_nan795, %3117, !dbg !1096
  %3118 = or i1 %is_snan794, %is_snan796, !dbg !1096
  %3119 = bitcast float %3084 to i32, !dbg !1096
  %3120 = bitcast float %3084 to i32, !dbg !1096
  %3121 = and i32 %3120, 2139095040, !dbg !1096
  %3122 = icmp eq i32 %3121, 2139095040, !dbg !1096
  %3123 = and i32 %3120, 8388607, !dbg !1096
  %3124 = icmp ne i32 %3123, 0, !dbg !1096
  %is_nan797 = and i1 %3122, %3124, !dbg !1096
  %3125 = and i32 %3119, 4194304, !dbg !1096
  %3126 = icmp eq i32 %3125, 0, !dbg !1096
  %is_snan798 = and i1 %is_nan797, %3126, !dbg !1096
  %3127 = or i1 %3118, %is_snan798, !dbg !1096
  %3128 = bitcast float %2749 to i32, !dbg !1096
  %3129 = and i32 %3128, 2147483647, !dbg !1096
  %is_zero799 = icmp eq i32 %3129, 0, !dbg !1096
  %3130 = bitcast float %763 to i32, !dbg !1096
  %3131 = and i32 %3130, 2139095040, !dbg !1096
  %3132 = icmp eq i32 %3131, 2139095040, !dbg !1096
  %3133 = and i32 %3130, 8388607, !dbg !1096
  %3134 = icmp eq i32 %3133, 0, !dbg !1096
  %is_inf800 = and i1 %3132, %3134, !dbg !1096
  %3135 = and i1 %is_zero799, %is_inf800, !dbg !1096
  %3136 = bitcast float %2749 to i32, !dbg !1096
  %3137 = and i32 %3136, 2139095040, !dbg !1096
  %3138 = icmp eq i32 %3137, 2139095040, !dbg !1096
  %3139 = and i32 %3136, 8388607, !dbg !1096
  %3140 = icmp eq i32 %3139, 0, !dbg !1096
  %is_inf801 = and i1 %3138, %3140, !dbg !1096
  %3141 = bitcast float %763 to i32, !dbg !1096
  %3142 = and i32 %3141, 2147483647, !dbg !1096
  %is_zero802 = icmp eq i32 %3142, 0, !dbg !1096
  %3143 = and i1 %is_inf801, %is_zero802, !dbg !1096
  %3144 = or i1 %3135, %3143, !dbg !1096
  %3145 = or i1 %3127, %3144, !dbg !1096
  br i1 %3145, label %3146, label %3148, !dbg !1096

3146:                                             ; preds = %3101
  %3147 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3148, !dbg !1096

3148:                                             ; preds = %3101, %3146
  %3149 = call float @llvm.nvvm.fma.rn.f(float %2749, float %763, float %3084) #5, !dbg !1096
  %3150 = bitcast float %2749 to i32, !dbg !1096
  %3151 = and i32 %3150, 2139095040, !dbg !1096
  %is_finite803 = icmp ne i32 %3151, 2139095040, !dbg !1096
  %3152 = and i1 true, %is_finite803, !dbg !1096
  %3153 = bitcast float %763 to i32, !dbg !1096
  %3154 = and i32 %3153, 2139095040, !dbg !1096
  %is_finite804 = icmp ne i32 %3154, 2139095040, !dbg !1096
  %3155 = and i1 %3152, %is_finite804, !dbg !1096
  %3156 = bitcast float %3149 to i32, !dbg !1096
  %3157 = and i32 %3156, 2139095040, !dbg !1096
  %3158 = icmp eq i32 %3157, 2139095040, !dbg !1096
  %3159 = and i32 %3156, 8388607, !dbg !1096
  %3160 = icmp eq i32 %3159, 0, !dbg !1096
  %is_inf805 = and i1 %3158, %3160, !dbg !1096
  %3161 = bitcast float %3149 to i32, !dbg !1096
  %3162 = and i32 %3161, 2147483647, !dbg !1096
  %is_maxfinite806 = icmp eq i32 %3162, 2139095039, !dbg !1096
  %3163 = bitcast float %3149 to i32, !dbg !1096
  %3164 = and i32 %3163, -2147483648, !dbg !1096
  %3165 = icmp eq i32 %3164, 0, !dbg !1096
  %3166 = icmp ne i32 %3164, 0, !dbg !1096
  %is_pos_inf807 = and i1 %is_inf805, %3165, !dbg !1096
  %is_neg_inf808 = and i1 %is_inf805, %3166, !dbg !1096
  %is_pos_max809 = and i1 %is_maxfinite806, %3165, !dbg !1096
  %is_neg_max810 = and i1 %is_maxfinite806, %3166, !dbg !1096
  %overflow_cond811 = and i1 %3155, %is_inf805, !dbg !1096
  br i1 %overflow_cond811, label %3167, label %3169, !dbg !1096

3167:                                             ; preds = %3148
  %3168 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3169, !dbg !1096

3169:                                             ; preds = %3148, %3167
  %3170 = bitcast float %2749 to i32, !dbg !1096
  %3171 = and i32 %3170, 2139095040, !dbg !1096
  %3172 = icmp eq i32 %3171, 0, !dbg !1096
  %3173 = and i32 %3170, 8388607, !dbg !1096
  %3174 = icmp ne i32 %3173, 0, !dbg !1096
  %is_subnormal812 = and i1 %3172, %3174, !dbg !1096
  %3175 = xor i1 %is_subnormal812, true, !dbg !1096
  %3176 = and i1 true, %3175, !dbg !1096
  %3177 = bitcast float %763 to i32, !dbg !1096
  %3178 = and i32 %3177, 2139095040, !dbg !1096
  %3179 = icmp eq i32 %3178, 0, !dbg !1096
  %3180 = and i32 %3177, 8388607, !dbg !1096
  %3181 = icmp ne i32 %3180, 0, !dbg !1096
  %is_subnormal813 = and i1 %3179, %3181, !dbg !1096
  %3182 = xor i1 %is_subnormal813, true, !dbg !1096
  %3183 = and i1 %3176, %3182, !dbg !1096
  %3184 = bitcast float %3084 to i32, !dbg !1096
  %3185 = and i32 %3184, 2139095040, !dbg !1096
  %3186 = icmp eq i32 %3185, 0, !dbg !1096
  %3187 = and i32 %3184, 8388607, !dbg !1096
  %3188 = icmp ne i32 %3187, 0, !dbg !1096
  %is_subnormal814 = and i1 %3186, %3188, !dbg !1096
  %3189 = xor i1 %is_subnormal814, true, !dbg !1096
  %3190 = and i1 %3183, %3189, !dbg !1096
  %3191 = bitcast float %3149 to i32, !dbg !1096
  %3192 = and i32 %3191, 2139095040, !dbg !1096
  %3193 = icmp eq i32 %3192, 0, !dbg !1096
  %3194 = and i32 %3191, 8388607, !dbg !1096
  %3195 = icmp ne i32 %3194, 0, !dbg !1096
  %is_subnormal815 = and i1 %3193, %3195, !dbg !1096
  %is_tiny816 = or i1 %is_subnormal815, false, !dbg !1096
  %underflow_cond817 = and i1 %3190, %is_tiny816, !dbg !1096
  br i1 %underflow_cond817, label %3196, label %3198, !dbg !1096

3196:                                             ; preds = %3169
  %3197 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3198, !dbg !1096

3198:                                             ; preds = %3169, %3196
  %insert97.i = insertvalue %struct.float2 undef, float %3008, 0, !dbg !1096
  %insert99.i = insertvalue %struct.float2 %insert97.i, float %3149, 1, !dbg !1096
  %3199 = bitcast float %2949 to i32, !dbg !1096
  %3200 = bitcast float %2949 to i32, !dbg !1096
  %3201 = and i32 %3200, 2139095040, !dbg !1096
  %3202 = icmp eq i32 %3201, 2139095040, !dbg !1096
  %3203 = and i32 %3200, 8388607, !dbg !1096
  %3204 = icmp ne i32 %3203, 0, !dbg !1096
  %is_nan818 = and i1 %3202, %3204, !dbg !1096
  %3205 = and i32 %3199, 4194304, !dbg !1096
  %3206 = icmp eq i32 %3205, 0, !dbg !1096
  %is_snan819 = and i1 %is_nan818, %3206, !dbg !1096
  %3207 = bitcast float %763 to i32, !dbg !1096
  %3208 = bitcast float %763 to i32, !dbg !1096
  %3209 = and i32 %3208, 2139095040, !dbg !1096
  %3210 = icmp eq i32 %3209, 2139095040, !dbg !1096
  %3211 = and i32 %3208, 8388607, !dbg !1096
  %3212 = icmp ne i32 %3211, 0, !dbg !1096
  %is_nan820 = and i1 %3210, %3212, !dbg !1096
  %3213 = and i32 %3207, 4194304, !dbg !1096
  %3214 = icmp eq i32 %3213, 0, !dbg !1096
  %is_snan821 = and i1 %is_nan820, %3214, !dbg !1096
  %3215 = or i1 %is_snan819, %is_snan821, !dbg !1096
  %3216 = bitcast float %3149 to i32, !dbg !1096
  %3217 = bitcast float %3149 to i32, !dbg !1096
  %3218 = and i32 %3217, 2139095040, !dbg !1096
  %3219 = icmp eq i32 %3218, 2139095040, !dbg !1096
  %3220 = and i32 %3217, 8388607, !dbg !1096
  %3221 = icmp ne i32 %3220, 0, !dbg !1096
  %is_nan822 = and i1 %3219, %3221, !dbg !1096
  %3222 = and i32 %3216, 4194304, !dbg !1096
  %3223 = icmp eq i32 %3222, 0, !dbg !1096
  %is_snan823 = and i1 %is_nan822, %3223, !dbg !1096
  %3224 = or i1 %3215, %is_snan823, !dbg !1096
  %3225 = bitcast float %2949 to i32, !dbg !1096
  %3226 = and i32 %3225, 2147483647, !dbg !1096
  %is_zero824 = icmp eq i32 %3226, 0, !dbg !1096
  %3227 = bitcast float %763 to i32, !dbg !1096
  %3228 = and i32 %3227, 2139095040, !dbg !1096
  %3229 = icmp eq i32 %3228, 2139095040, !dbg !1096
  %3230 = and i32 %3227, 8388607, !dbg !1096
  %3231 = icmp eq i32 %3230, 0, !dbg !1096
  %is_inf825 = and i1 %3229, %3231, !dbg !1096
  %3232 = and i1 %is_zero824, %is_inf825, !dbg !1096
  %3233 = bitcast float %2949 to i32, !dbg !1096
  %3234 = and i32 %3233, 2139095040, !dbg !1096
  %3235 = icmp eq i32 %3234, 2139095040, !dbg !1096
  %3236 = and i32 %3233, 8388607, !dbg !1096
  %3237 = icmp eq i32 %3236, 0, !dbg !1096
  %is_inf826 = and i1 %3235, %3237, !dbg !1096
  %3238 = bitcast float %763 to i32, !dbg !1096
  %3239 = and i32 %3238, 2147483647, !dbg !1096
  %is_zero827 = icmp eq i32 %3239, 0, !dbg !1096
  %3240 = and i1 %is_inf826, %is_zero827, !dbg !1096
  %3241 = or i1 %3232, %3240, !dbg !1096
  %3242 = or i1 %3224, %3241, !dbg !1096
  br i1 %3242, label %3243, label %3245, !dbg !1096

3243:                                             ; preds = %3198
  %3244 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3245, !dbg !1096

3245:                                             ; preds = %3198, %3243
  %3246 = call float @llvm.nvvm.fma.rn.f(float %2949, float %763, float %3149) #5, !dbg !1096
  %3247 = bitcast float %2949 to i32, !dbg !1096
  %3248 = and i32 %3247, 2139095040, !dbg !1096
  %is_finite828 = icmp ne i32 %3248, 2139095040, !dbg !1096
  %3249 = and i1 true, %is_finite828, !dbg !1096
  %3250 = bitcast float %763 to i32, !dbg !1096
  %3251 = and i32 %3250, 2139095040, !dbg !1096
  %is_finite829 = icmp ne i32 %3251, 2139095040, !dbg !1096
  %3252 = and i1 %3249, %is_finite829, !dbg !1096
  %3253 = bitcast float %3246 to i32, !dbg !1096
  %3254 = and i32 %3253, 2139095040, !dbg !1096
  %3255 = icmp eq i32 %3254, 2139095040, !dbg !1096
  %3256 = and i32 %3253, 8388607, !dbg !1096
  %3257 = icmp eq i32 %3256, 0, !dbg !1096
  %is_inf830 = and i1 %3255, %3257, !dbg !1096
  %3258 = bitcast float %3246 to i32, !dbg !1096
  %3259 = and i32 %3258, 2147483647, !dbg !1096
  %is_maxfinite831 = icmp eq i32 %3259, 2139095039, !dbg !1096
  %3260 = bitcast float %3246 to i32, !dbg !1096
  %3261 = and i32 %3260, -2147483648, !dbg !1096
  %3262 = icmp eq i32 %3261, 0, !dbg !1096
  %3263 = icmp ne i32 %3261, 0, !dbg !1096
  %is_pos_inf832 = and i1 %is_inf830, %3262, !dbg !1096
  %is_neg_inf833 = and i1 %is_inf830, %3263, !dbg !1096
  %is_pos_max834 = and i1 %is_maxfinite831, %3262, !dbg !1096
  %is_neg_max835 = and i1 %is_maxfinite831, %3263, !dbg !1096
  %overflow_cond836 = and i1 %3252, %is_inf830, !dbg !1096
  br i1 %overflow_cond836, label %3264, label %3266, !dbg !1096

3264:                                             ; preds = %3245
  %3265 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3266, !dbg !1096

3266:                                             ; preds = %3245, %3264
  %3267 = bitcast float %2949 to i32, !dbg !1096
  %3268 = and i32 %3267, 2139095040, !dbg !1096
  %3269 = icmp eq i32 %3268, 0, !dbg !1096
  %3270 = and i32 %3267, 8388607, !dbg !1096
  %3271 = icmp ne i32 %3270, 0, !dbg !1096
  %is_subnormal837 = and i1 %3269, %3271, !dbg !1096
  %3272 = xor i1 %is_subnormal837, true, !dbg !1096
  %3273 = and i1 true, %3272, !dbg !1096
  %3274 = bitcast float %763 to i32, !dbg !1096
  %3275 = and i32 %3274, 2139095040, !dbg !1096
  %3276 = icmp eq i32 %3275, 0, !dbg !1096
  %3277 = and i32 %3274, 8388607, !dbg !1096
  %3278 = icmp ne i32 %3277, 0, !dbg !1096
  %is_subnormal838 = and i1 %3276, %3278, !dbg !1096
  %3279 = xor i1 %is_subnormal838, true, !dbg !1096
  %3280 = and i1 %3273, %3279, !dbg !1096
  %3281 = bitcast float %3149 to i32, !dbg !1096
  %3282 = and i32 %3281, 2139095040, !dbg !1096
  %3283 = icmp eq i32 %3282, 0, !dbg !1096
  %3284 = and i32 %3281, 8388607, !dbg !1096
  %3285 = icmp ne i32 %3284, 0, !dbg !1096
  %is_subnormal839 = and i1 %3283, %3285, !dbg !1096
  %3286 = xor i1 %is_subnormal839, true, !dbg !1096
  %3287 = and i1 %3280, %3286, !dbg !1096
  %3288 = bitcast float %3246 to i32, !dbg !1096
  %3289 = and i32 %3288, 2139095040, !dbg !1096
  %3290 = icmp eq i32 %3289, 0, !dbg !1096
  %3291 = and i32 %3288, 8388607, !dbg !1096
  %3292 = icmp ne i32 %3291, 0, !dbg !1096
  %is_subnormal840 = and i1 %3290, %3292, !dbg !1096
  %is_tiny841 = or i1 %is_subnormal840, false, !dbg !1096
  %underflow_cond842 = and i1 %3287, %is_tiny841, !dbg !1096
  br i1 %underflow_cond842, label %3293, label %3295, !dbg !1096

3293:                                             ; preds = %3266
  %3294 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3295, !dbg !1096

3295:                                             ; preds = %3266, %3293
  %3296 = call float @llvm.nvvm.round.f(float %3008) #5, !dbg !1096
  %3297 = bitcast float %3008 to i32, !dbg !1096
  %3298 = bitcast float %3008 to i32, !dbg !1096
  %3299 = and i32 %3298, 2139095040, !dbg !1096
  %3300 = icmp eq i32 %3299, 2139095040, !dbg !1096
  %3301 = and i32 %3298, 8388607, !dbg !1096
  %3302 = icmp ne i32 %3301, 0, !dbg !1096
  %is_nan843 = and i1 %3300, %3302, !dbg !1096
  %3303 = and i32 %3297, 4194304, !dbg !1096
  %3304 = icmp eq i32 %3303, 0, !dbg !1096
  %is_snan844 = and i1 %is_nan843, %3304, !dbg !1096
  %3305 = bitcast float %3296 to i32, !dbg !1096
  %3306 = bitcast float %3296 to i32, !dbg !1096
  %3307 = and i32 %3306, 2139095040, !dbg !1096
  %3308 = icmp eq i32 %3307, 2139095040, !dbg !1096
  %3309 = and i32 %3306, 8388607, !dbg !1096
  %3310 = icmp ne i32 %3309, 0, !dbg !1096
  %is_nan845 = and i1 %3308, %3310, !dbg !1096
  %3311 = and i32 %3305, 4194304, !dbg !1096
  %3312 = icmp eq i32 %3311, 0, !dbg !1096
  %is_snan846 = and i1 %is_nan845, %3312, !dbg !1096
  %3313 = or i1 %is_snan844, %is_snan846, !dbg !1096
  %3314 = bitcast float %3008 to i32, !dbg !1096
  %3315 = and i32 %3314, 2139095040, !dbg !1096
  %3316 = icmp eq i32 %3315, 2139095040, !dbg !1096
  %3317 = and i32 %3314, 8388607, !dbg !1096
  %3318 = icmp eq i32 %3317, 0, !dbg !1096
  %is_inf847 = and i1 %3316, %3318, !dbg !1096
  %3319 = bitcast float %3296 to i32, !dbg !1096
  %3320 = and i32 %3319, 2139095040, !dbg !1096
  %3321 = icmp eq i32 %3320, 2139095040, !dbg !1096
  %3322 = and i32 %3319, 8388607, !dbg !1096
  %3323 = icmp eq i32 %3322, 0, !dbg !1096
  %is_inf848 = and i1 %3321, %3323, !dbg !1096
  %3324 = and i1 %is_inf847, %is_inf848, !dbg !1096
  %3325 = bitcast float %3008 to i32, !dbg !1096
  %3326 = bitcast float %3296 to i32, !dbg !1096
  %3327 = and i32 %3325, -2147483648, !dbg !1096
  %3328 = and i32 %3326, -2147483648, !dbg !1096
  %3329 = icmp eq i32 %3327, %3328, !dbg !1096
  %3330 = and i1 %3324, %3329, !dbg !1096
  %3331 = or i1 %3313, %3330, !dbg !1096
  br i1 %3331, label %3332, label %3334, !dbg !1096

3332:                                             ; preds = %3295
  %3333 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3334, !dbg !1096

3334:                                             ; preds = %3295, %3332
  %3335 = fsub float %3008, %3296, !dbg !1096
  %3336 = bitcast float %3008 to i32, !dbg !1096
  %3337 = and i32 %3336, 2139095040, !dbg !1096
  %is_finite849 = icmp ne i32 %3337, 2139095040, !dbg !1096
  %3338 = and i1 true, %is_finite849, !dbg !1096
  %3339 = bitcast float %3296 to i32, !dbg !1096
  %3340 = and i32 %3339, 2139095040, !dbg !1096
  %is_finite850 = icmp ne i32 %3340, 2139095040, !dbg !1096
  %3341 = and i1 %3338, %is_finite850, !dbg !1096
  %3342 = bitcast float %3335 to i32, !dbg !1096
  %3343 = and i32 %3342, 2139095040, !dbg !1096
  %3344 = icmp eq i32 %3343, 2139095040, !dbg !1096
  %3345 = and i32 %3342, 8388607, !dbg !1096
  %3346 = icmp eq i32 %3345, 0, !dbg !1096
  %is_inf851 = and i1 %3344, %3346, !dbg !1096
  %3347 = bitcast float %3335 to i32, !dbg !1096
  %3348 = and i32 %3347, 2147483647, !dbg !1096
  %is_maxfinite852 = icmp eq i32 %3348, 2139095039, !dbg !1096
  %3349 = bitcast float %3335 to i32, !dbg !1096
  %3350 = and i32 %3349, -2147483648, !dbg !1096
  %3351 = icmp eq i32 %3350, 0, !dbg !1096
  %3352 = icmp ne i32 %3350, 0, !dbg !1096
  %is_pos_inf853 = and i1 %is_inf851, %3351, !dbg !1096
  %is_neg_inf854 = and i1 %is_inf851, %3352, !dbg !1096
  %is_pos_max855 = and i1 %is_maxfinite852, %3351, !dbg !1096
  %is_neg_max856 = and i1 %is_maxfinite852, %3352, !dbg !1096
  %overflow_cond857 = and i1 %3341, %is_inf851, !dbg !1096
  br i1 %overflow_cond857, label %3353, label %3355, !dbg !1096

3353:                                             ; preds = %3334
  %3354 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3355, !dbg !1096

3355:                                             ; preds = %3334, %3353
  %3356 = bitcast float %3335 to i32, !dbg !1096
  %3357 = bitcast float %3335 to i32, !dbg !1096
  %3358 = and i32 %3357, 2139095040, !dbg !1096
  %3359 = icmp eq i32 %3358, 2139095040, !dbg !1096
  %3360 = and i32 %3357, 8388607, !dbg !1096
  %3361 = icmp ne i32 %3360, 0, !dbg !1096
  %is_nan858 = and i1 %3359, %3361, !dbg !1096
  %3362 = and i32 %3356, 4194304, !dbg !1096
  %3363 = icmp eq i32 %3362, 0, !dbg !1096
  %is_snan859 = and i1 %is_nan858, %3363, !dbg !1096
  %3364 = bitcast float %3246 to i32, !dbg !1096
  %3365 = bitcast float %3246 to i32, !dbg !1096
  %3366 = and i32 %3365, 2139095040, !dbg !1096
  %3367 = icmp eq i32 %3366, 2139095040, !dbg !1096
  %3368 = and i32 %3365, 8388607, !dbg !1096
  %3369 = icmp ne i32 %3368, 0, !dbg !1096
  %is_nan860 = and i1 %3367, %3369, !dbg !1096
  %3370 = and i32 %3364, 4194304, !dbg !1096
  %3371 = icmp eq i32 %3370, 0, !dbg !1096
  %is_snan861 = and i1 %is_nan860, %3371, !dbg !1096
  %3372 = or i1 %is_snan859, %is_snan861, !dbg !1096
  %3373 = bitcast float %3335 to i32, !dbg !1096
  %3374 = and i32 %3373, 2139095040, !dbg !1096
  %3375 = icmp eq i32 %3374, 2139095040, !dbg !1096
  %3376 = and i32 %3373, 8388607, !dbg !1096
  %3377 = icmp eq i32 %3376, 0, !dbg !1096
  %is_inf862 = and i1 %3375, %3377, !dbg !1096
  %3378 = bitcast float %3246 to i32, !dbg !1096
  %3379 = and i32 %3378, 2139095040, !dbg !1096
  %3380 = icmp eq i32 %3379, 2139095040, !dbg !1096
  %3381 = and i32 %3378, 8388607, !dbg !1096
  %3382 = icmp eq i32 %3381, 0, !dbg !1096
  %is_inf863 = and i1 %3380, %3382, !dbg !1096
  %3383 = and i1 %is_inf862, %is_inf863, !dbg !1096
  %3384 = bitcast float %3335 to i32, !dbg !1096
  %3385 = bitcast float %3246 to i32, !dbg !1096
  %3386 = and i32 %3384, -2147483648, !dbg !1096
  %3387 = and i32 %3385, -2147483648, !dbg !1096
  %3388 = icmp ne i32 %3386, %3387, !dbg !1096
  %3389 = and i1 %3383, %3388, !dbg !1096
  %3390 = or i1 %3372, %3389, !dbg !1096
  br i1 %3390, label %3391, label %3393, !dbg !1096

3391:                                             ; preds = %3355
  %3392 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3393, !dbg !1096

3393:                                             ; preds = %3355, %3391
  %3394 = fadd float %3335, %3246, !dbg !1096
  %3395 = bitcast float %3335 to i32, !dbg !1096
  %3396 = and i32 %3395, 2139095040, !dbg !1096
  %is_finite864 = icmp ne i32 %3396, 2139095040, !dbg !1096
  %3397 = and i1 true, %is_finite864, !dbg !1096
  %3398 = bitcast float %3246 to i32, !dbg !1096
  %3399 = and i32 %3398, 2139095040, !dbg !1096
  %is_finite865 = icmp ne i32 %3399, 2139095040, !dbg !1096
  %3400 = and i1 %3397, %is_finite865, !dbg !1096
  %3401 = bitcast float %3394 to i32, !dbg !1096
  %3402 = and i32 %3401, 2139095040, !dbg !1096
  %3403 = icmp eq i32 %3402, 2139095040, !dbg !1096
  %3404 = and i32 %3401, 8388607, !dbg !1096
  %3405 = icmp eq i32 %3404, 0, !dbg !1096
  %is_inf866 = and i1 %3403, %3405, !dbg !1096
  %3406 = bitcast float %3394 to i32, !dbg !1096
  %3407 = and i32 %3406, 2147483647, !dbg !1096
  %is_maxfinite867 = icmp eq i32 %3407, 2139095039, !dbg !1096
  %3408 = bitcast float %3394 to i32, !dbg !1096
  %3409 = and i32 %3408, -2147483648, !dbg !1096
  %3410 = icmp eq i32 %3409, 0, !dbg !1096
  %3411 = icmp ne i32 %3409, 0, !dbg !1096
  %is_pos_inf868 = and i1 %is_inf866, %3410, !dbg !1096
  %is_neg_inf869 = and i1 %is_inf866, %3411, !dbg !1096
  %is_pos_max870 = and i1 %is_maxfinite867, %3410, !dbg !1096
  %is_neg_max871 = and i1 %is_maxfinite867, %3411, !dbg !1096
  %overflow_cond872 = and i1 %3400, %is_inf866, !dbg !1096
  br i1 %overflow_cond872, label %3412, label %3414, !dbg !1096

3412:                                             ; preds = %3393
  %3413 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3414, !dbg !1096

3414:                                             ; preds = %3393, %3412
  %3415 = bitcast float %3394 to i32, !dbg !1096
  %3416 = bitcast float %3394 to i32, !dbg !1096
  %3417 = and i32 %3416, 2139095040, !dbg !1096
  %3418 = icmp eq i32 %3417, 2139095040, !dbg !1096
  %3419 = and i32 %3416, 8388607, !dbg !1096
  %3420 = icmp ne i32 %3419, 0, !dbg !1096
  %is_nan873 = and i1 %3418, %3420, !dbg !1096
  %3421 = and i32 %3415, 4194304, !dbg !1096
  %3422 = icmp eq i32 %3421, 0, !dbg !1096
  %is_snan874 = and i1 %is_nan873, %3422, !dbg !1096
  %3423 = or i1 false, %is_snan874, !dbg !1096
  %3424 = or i1 %3423, false, !dbg !1096
  %3425 = bitcast float %3394 to i32, !dbg !1096
  %3426 = and i32 %3425, 2139095040, !dbg !1096
  %3427 = icmp eq i32 %3426, 2139095040, !dbg !1096
  %3428 = and i32 %3425, 8388607, !dbg !1096
  %3429 = icmp eq i32 %3428, 0, !dbg !1096
  %is_inf875 = and i1 %3427, %3429, !dbg !1096
  %3430 = and i1 false, %is_inf875, !dbg !1096
  %3431 = bitcast float %3394 to i32, !dbg !1096
  %3432 = and i32 %3431, 2147483647, !dbg !1096
  %is_zero876 = icmp eq i32 %3432, 0, !dbg !1096
  %3433 = and i1 false, %is_zero876, !dbg !1096
  %3434 = or i1 %3430, %3433, !dbg !1096
  %3435 = or i1 %3424, %3434, !dbg !1096
  br i1 %3435, label %3436, label %3438, !dbg !1096

3436:                                             ; preds = %3414
  %3437 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3438, !dbg !1096

3438:                                             ; preds = %3414, %3436
  %3439 = call float @llvm.nvvm.fma.rn.f(float 0x3F23F971C0000000, float %3394, float 0x3F55F0BDA0000000) #5, !dbg !1096
  %3440 = bitcast float %3394 to i32, !dbg !1096
  %3441 = and i32 %3440, 2139095040, !dbg !1096
  %is_finite877 = icmp ne i32 %3441, 2139095040, !dbg !1096
  %3442 = and i1 true, %is_finite877, !dbg !1096
  %3443 = bitcast float %3439 to i32, !dbg !1096
  %3444 = and i32 %3443, 2139095040, !dbg !1096
  %3445 = icmp eq i32 %3444, 2139095040, !dbg !1096
  %3446 = and i32 %3443, 8388607, !dbg !1096
  %3447 = icmp eq i32 %3446, 0, !dbg !1096
  %is_inf878 = and i1 %3445, %3447, !dbg !1096
  %3448 = bitcast float %3439 to i32, !dbg !1096
  %3449 = and i32 %3448, 2147483647, !dbg !1096
  %is_maxfinite879 = icmp eq i32 %3449, 2139095039, !dbg !1096
  %3450 = bitcast float %3439 to i32, !dbg !1096
  %3451 = and i32 %3450, -2147483648, !dbg !1096
  %3452 = icmp eq i32 %3451, 0, !dbg !1096
  %3453 = icmp ne i32 %3451, 0, !dbg !1096
  %is_pos_inf880 = and i1 %is_inf878, %3452, !dbg !1096
  %is_neg_inf881 = and i1 %is_inf878, %3453, !dbg !1096
  %is_pos_max882 = and i1 %is_maxfinite879, %3452, !dbg !1096
  %is_neg_max883 = and i1 %is_maxfinite879, %3453, !dbg !1096
  %overflow_cond884 = and i1 %3442, %is_inf878, !dbg !1096
  br i1 %overflow_cond884, label %3454, label %3456, !dbg !1096

3454:                                             ; preds = %3438
  %3455 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3456, !dbg !1096

3456:                                             ; preds = %3438, %3454
  %3457 = bitcast float %3394 to i32, !dbg !1096
  %3458 = and i32 %3457, 2139095040, !dbg !1096
  %3459 = icmp eq i32 %3458, 0, !dbg !1096
  %3460 = and i32 %3457, 8388607, !dbg !1096
  %3461 = icmp ne i32 %3460, 0, !dbg !1096
  %is_subnormal885 = and i1 %3459, %3461, !dbg !1096
  %3462 = xor i1 %is_subnormal885, true, !dbg !1096
  %3463 = and i1 true, %3462, !dbg !1096
  %3464 = and i1 %3463, true, !dbg !1096
  %3465 = bitcast float %3439 to i32, !dbg !1096
  %3466 = and i32 %3465, 2139095040, !dbg !1096
  %3467 = icmp eq i32 %3466, 0, !dbg !1096
  %3468 = and i32 %3465, 8388607, !dbg !1096
  %3469 = icmp ne i32 %3468, 0, !dbg !1096
  %is_subnormal886 = and i1 %3467, %3469, !dbg !1096
  %is_tiny887 = or i1 %is_subnormal886, false, !dbg !1096
  %underflow_cond888 = and i1 %3464, %is_tiny887, !dbg !1096
  br i1 %underflow_cond888, label %3470, label %3472, !dbg !1096

3470:                                             ; preds = %3456
  %3471 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3472, !dbg !1096

3472:                                             ; preds = %3456, %3470
  %3473 = bitcast float %3439 to i32, !dbg !1096
  %3474 = bitcast float %3439 to i32, !dbg !1096
  %3475 = and i32 %3474, 2139095040, !dbg !1096
  %3476 = icmp eq i32 %3475, 2139095040, !dbg !1096
  %3477 = and i32 %3474, 8388607, !dbg !1096
  %3478 = icmp ne i32 %3477, 0, !dbg !1096
  %is_nan889 = and i1 %3476, %3478, !dbg !1096
  %3479 = and i32 %3473, 4194304, !dbg !1096
  %3480 = icmp eq i32 %3479, 0, !dbg !1096
  %is_snan890 = and i1 %is_nan889, %3480, !dbg !1096
  %3481 = bitcast float %3394 to i32, !dbg !1096
  %3482 = bitcast float %3394 to i32, !dbg !1096
  %3483 = and i32 %3482, 2139095040, !dbg !1096
  %3484 = icmp eq i32 %3483, 2139095040, !dbg !1096
  %3485 = and i32 %3482, 8388607, !dbg !1096
  %3486 = icmp ne i32 %3485, 0, !dbg !1096
  %is_nan891 = and i1 %3484, %3486, !dbg !1096
  %3487 = and i32 %3481, 4194304, !dbg !1096
  %3488 = icmp eq i32 %3487, 0, !dbg !1096
  %is_snan892 = and i1 %is_nan891, %3488, !dbg !1096
  %3489 = or i1 %is_snan890, %is_snan892, !dbg !1096
  %3490 = or i1 %3489, false, !dbg !1096
  %3491 = bitcast float %3439 to i32, !dbg !1096
  %3492 = and i32 %3491, 2147483647, !dbg !1096
  %is_zero893 = icmp eq i32 %3492, 0, !dbg !1096
  %3493 = bitcast float %3394 to i32, !dbg !1096
  %3494 = and i32 %3493, 2139095040, !dbg !1096
  %3495 = icmp eq i32 %3494, 2139095040, !dbg !1096
  %3496 = and i32 %3493, 8388607, !dbg !1096
  %3497 = icmp eq i32 %3496, 0, !dbg !1096
  %is_inf894 = and i1 %3495, %3497, !dbg !1096
  %3498 = and i1 %is_zero893, %is_inf894, !dbg !1096
  %3499 = bitcast float %3439 to i32, !dbg !1096
  %3500 = and i32 %3499, 2139095040, !dbg !1096
  %3501 = icmp eq i32 %3500, 2139095040, !dbg !1096
  %3502 = and i32 %3499, 8388607, !dbg !1096
  %3503 = icmp eq i32 %3502, 0, !dbg !1096
  %is_inf895 = and i1 %3501, %3503, !dbg !1096
  %3504 = bitcast float %3394 to i32, !dbg !1096
  %3505 = and i32 %3504, 2147483647, !dbg !1096
  %is_zero896 = icmp eq i32 %3505, 0, !dbg !1096
  %3506 = and i1 %is_inf895, %is_zero896, !dbg !1096
  %3507 = or i1 %3498, %3506, !dbg !1096
  %3508 = or i1 %3490, %3507, !dbg !1096
  br i1 %3508, label %3509, label %3511, !dbg !1096

3509:                                             ; preds = %3472
  %3510 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3511, !dbg !1096

3511:                                             ; preds = %3472, %3509
  %3512 = call float @llvm.nvvm.fma.rn.f(float %3439, float %3394, float 0x3F83B30AC0000000) #5, !dbg !1096
  %3513 = bitcast float %3439 to i32, !dbg !1096
  %3514 = and i32 %3513, 2139095040, !dbg !1096
  %is_finite897 = icmp ne i32 %3514, 2139095040, !dbg !1096
  %3515 = and i1 true, %is_finite897, !dbg !1096
  %3516 = bitcast float %3394 to i32, !dbg !1096
  %3517 = and i32 %3516, 2139095040, !dbg !1096
  %is_finite898 = icmp ne i32 %3517, 2139095040, !dbg !1096
  %3518 = and i1 %3515, %is_finite898, !dbg !1096
  %3519 = bitcast float %3512 to i32, !dbg !1096
  %3520 = and i32 %3519, 2139095040, !dbg !1096
  %3521 = icmp eq i32 %3520, 2139095040, !dbg !1096
  %3522 = and i32 %3519, 8388607, !dbg !1096
  %3523 = icmp eq i32 %3522, 0, !dbg !1096
  %is_inf899 = and i1 %3521, %3523, !dbg !1096
  %3524 = bitcast float %3512 to i32, !dbg !1096
  %3525 = and i32 %3524, 2147483647, !dbg !1096
  %is_maxfinite900 = icmp eq i32 %3525, 2139095039, !dbg !1096
  %3526 = bitcast float %3512 to i32, !dbg !1096
  %3527 = and i32 %3526, -2147483648, !dbg !1096
  %3528 = icmp eq i32 %3527, 0, !dbg !1096
  %3529 = icmp ne i32 %3527, 0, !dbg !1096
  %is_pos_inf901 = and i1 %is_inf899, %3528, !dbg !1096
  %is_neg_inf902 = and i1 %is_inf899, %3529, !dbg !1096
  %is_pos_max903 = and i1 %is_maxfinite900, %3528, !dbg !1096
  %is_neg_max904 = and i1 %is_maxfinite900, %3529, !dbg !1096
  %overflow_cond905 = and i1 %3518, %is_inf899, !dbg !1096
  br i1 %overflow_cond905, label %3530, label %3532, !dbg !1096

3530:                                             ; preds = %3511
  %3531 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3532, !dbg !1096

3532:                                             ; preds = %3511, %3530
  %3533 = bitcast float %3439 to i32, !dbg !1096
  %3534 = and i32 %3533, 2139095040, !dbg !1096
  %3535 = icmp eq i32 %3534, 0, !dbg !1096
  %3536 = and i32 %3533, 8388607, !dbg !1096
  %3537 = icmp ne i32 %3536, 0, !dbg !1096
  %is_subnormal906 = and i1 %3535, %3537, !dbg !1096
  %3538 = xor i1 %is_subnormal906, true, !dbg !1096
  %3539 = and i1 true, %3538, !dbg !1096
  %3540 = bitcast float %3394 to i32, !dbg !1096
  %3541 = and i32 %3540, 2139095040, !dbg !1096
  %3542 = icmp eq i32 %3541, 0, !dbg !1096
  %3543 = and i32 %3540, 8388607, !dbg !1096
  %3544 = icmp ne i32 %3543, 0, !dbg !1096
  %is_subnormal907 = and i1 %3542, %3544, !dbg !1096
  %3545 = xor i1 %is_subnormal907, true, !dbg !1096
  %3546 = and i1 %3539, %3545, !dbg !1096
  %3547 = and i1 %3546, true, !dbg !1096
  %3548 = bitcast float %3512 to i32, !dbg !1096
  %3549 = and i32 %3548, 2139095040, !dbg !1096
  %3550 = icmp eq i32 %3549, 0, !dbg !1096
  %3551 = and i32 %3548, 8388607, !dbg !1096
  %3552 = icmp ne i32 %3551, 0, !dbg !1096
  %is_subnormal908 = and i1 %3550, %3552, !dbg !1096
  %is_tiny909 = or i1 %is_subnormal908, false, !dbg !1096
  %underflow_cond910 = and i1 %3547, %is_tiny909, !dbg !1096
  br i1 %underflow_cond910, label %3553, label %3555, !dbg !1096

3553:                                             ; preds = %3532
  %3554 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3555, !dbg !1096

3555:                                             ; preds = %3532, %3553
  %3556 = bitcast float %3512 to i32, !dbg !1096
  %3557 = bitcast float %3512 to i32, !dbg !1096
  %3558 = and i32 %3557, 2139095040, !dbg !1096
  %3559 = icmp eq i32 %3558, 2139095040, !dbg !1096
  %3560 = and i32 %3557, 8388607, !dbg !1096
  %3561 = icmp ne i32 %3560, 0, !dbg !1096
  %is_nan911 = and i1 %3559, %3561, !dbg !1096
  %3562 = and i32 %3556, 4194304, !dbg !1096
  %3563 = icmp eq i32 %3562, 0, !dbg !1096
  %is_snan912 = and i1 %is_nan911, %3563, !dbg !1096
  %3564 = bitcast float %3394 to i32, !dbg !1096
  %3565 = bitcast float %3394 to i32, !dbg !1096
  %3566 = and i32 %3565, 2139095040, !dbg !1096
  %3567 = icmp eq i32 %3566, 2139095040, !dbg !1096
  %3568 = and i32 %3565, 8388607, !dbg !1096
  %3569 = icmp ne i32 %3568, 0, !dbg !1096
  %is_nan913 = and i1 %3567, %3569, !dbg !1096
  %3570 = and i32 %3564, 4194304, !dbg !1096
  %3571 = icmp eq i32 %3570, 0, !dbg !1096
  %is_snan914 = and i1 %is_nan913, %3571, !dbg !1096
  %3572 = or i1 %is_snan912, %is_snan914, !dbg !1096
  %3573 = or i1 %3572, false, !dbg !1096
  %3574 = bitcast float %3512 to i32, !dbg !1096
  %3575 = and i32 %3574, 2147483647, !dbg !1096
  %is_zero915 = icmp eq i32 %3575, 0, !dbg !1096
  %3576 = bitcast float %3394 to i32, !dbg !1096
  %3577 = and i32 %3576, 2139095040, !dbg !1096
  %3578 = icmp eq i32 %3577, 2139095040, !dbg !1096
  %3579 = and i32 %3576, 8388607, !dbg !1096
  %3580 = icmp eq i32 %3579, 0, !dbg !1096
  %is_inf916 = and i1 %3578, %3580, !dbg !1096
  %3581 = and i1 %is_zero915, %is_inf916, !dbg !1096
  %3582 = bitcast float %3512 to i32, !dbg !1096
  %3583 = and i32 %3582, 2139095040, !dbg !1096
  %3584 = icmp eq i32 %3583, 2139095040, !dbg !1096
  %3585 = and i32 %3582, 8388607, !dbg !1096
  %3586 = icmp eq i32 %3585, 0, !dbg !1096
  %is_inf917 = and i1 %3584, %3586, !dbg !1096
  %3587 = bitcast float %3394 to i32, !dbg !1096
  %3588 = and i32 %3587, 2147483647, !dbg !1096
  %is_zero918 = icmp eq i32 %3588, 0, !dbg !1096
  %3589 = and i1 %is_inf917, %is_zero918, !dbg !1096
  %3590 = or i1 %3581, %3589, !dbg !1096
  %3591 = or i1 %3573, %3590, !dbg !1096
  br i1 %3591, label %3592, label %3594, !dbg !1096

3592:                                             ; preds = %3555
  %3593 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3594, !dbg !1096

3594:                                             ; preds = %3555, %3592
  %3595 = call float @llvm.nvvm.fma.rn.f(float %3512, float %3394, float 0x3FAC6AF760000000) #5, !dbg !1096
  %3596 = bitcast float %3512 to i32, !dbg !1096
  %3597 = and i32 %3596, 2139095040, !dbg !1096
  %is_finite919 = icmp ne i32 %3597, 2139095040, !dbg !1096
  %3598 = and i1 true, %is_finite919, !dbg !1096
  %3599 = bitcast float %3394 to i32, !dbg !1096
  %3600 = and i32 %3599, 2139095040, !dbg !1096
  %is_finite920 = icmp ne i32 %3600, 2139095040, !dbg !1096
  %3601 = and i1 %3598, %is_finite920, !dbg !1096
  %3602 = bitcast float %3595 to i32, !dbg !1096
  %3603 = and i32 %3602, 2139095040, !dbg !1096
  %3604 = icmp eq i32 %3603, 2139095040, !dbg !1096
  %3605 = and i32 %3602, 8388607, !dbg !1096
  %3606 = icmp eq i32 %3605, 0, !dbg !1096
  %is_inf921 = and i1 %3604, %3606, !dbg !1096
  %3607 = bitcast float %3595 to i32, !dbg !1096
  %3608 = and i32 %3607, 2147483647, !dbg !1096
  %is_maxfinite922 = icmp eq i32 %3608, 2139095039, !dbg !1096
  %3609 = bitcast float %3595 to i32, !dbg !1096
  %3610 = and i32 %3609, -2147483648, !dbg !1096
  %3611 = icmp eq i32 %3610, 0, !dbg !1096
  %3612 = icmp ne i32 %3610, 0, !dbg !1096
  %is_pos_inf923 = and i1 %is_inf921, %3611, !dbg !1096
  %is_neg_inf924 = and i1 %is_inf921, %3612, !dbg !1096
  %is_pos_max925 = and i1 %is_maxfinite922, %3611, !dbg !1096
  %is_neg_max926 = and i1 %is_maxfinite922, %3612, !dbg !1096
  %overflow_cond927 = and i1 %3601, %is_inf921, !dbg !1096
  br i1 %overflow_cond927, label %3613, label %3615, !dbg !1096

3613:                                             ; preds = %3594
  %3614 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3615, !dbg !1096

3615:                                             ; preds = %3594, %3613
  %3616 = bitcast float %3512 to i32, !dbg !1096
  %3617 = and i32 %3616, 2139095040, !dbg !1096
  %3618 = icmp eq i32 %3617, 0, !dbg !1096
  %3619 = and i32 %3616, 8388607, !dbg !1096
  %3620 = icmp ne i32 %3619, 0, !dbg !1096
  %is_subnormal928 = and i1 %3618, %3620, !dbg !1096
  %3621 = xor i1 %is_subnormal928, true, !dbg !1096
  %3622 = and i1 true, %3621, !dbg !1096
  %3623 = bitcast float %3394 to i32, !dbg !1096
  %3624 = and i32 %3623, 2139095040, !dbg !1096
  %3625 = icmp eq i32 %3624, 0, !dbg !1096
  %3626 = and i32 %3623, 8388607, !dbg !1096
  %3627 = icmp ne i32 %3626, 0, !dbg !1096
  %is_subnormal929 = and i1 %3625, %3627, !dbg !1096
  %3628 = xor i1 %is_subnormal929, true, !dbg !1096
  %3629 = and i1 %3622, %3628, !dbg !1096
  %3630 = and i1 %3629, true, !dbg !1096
  %3631 = bitcast float %3595 to i32, !dbg !1096
  %3632 = and i32 %3631, 2139095040, !dbg !1096
  %3633 = icmp eq i32 %3632, 0, !dbg !1096
  %3634 = and i32 %3631, 8388607, !dbg !1096
  %3635 = icmp ne i32 %3634, 0, !dbg !1096
  %is_subnormal930 = and i1 %3633, %3635, !dbg !1096
  %is_tiny931 = or i1 %is_subnormal930, false, !dbg !1096
  %underflow_cond932 = and i1 %3630, %is_tiny931, !dbg !1096
  br i1 %underflow_cond932, label %3636, label %3638, !dbg !1096

3636:                                             ; preds = %3615
  %3637 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3638, !dbg !1096

3638:                                             ; preds = %3615, %3636
  %3639 = bitcast float %3595 to i32, !dbg !1096
  %3640 = bitcast float %3595 to i32, !dbg !1096
  %3641 = and i32 %3640, 2139095040, !dbg !1096
  %3642 = icmp eq i32 %3641, 2139095040, !dbg !1096
  %3643 = and i32 %3640, 8388607, !dbg !1096
  %3644 = icmp ne i32 %3643, 0, !dbg !1096
  %is_nan933 = and i1 %3642, %3644, !dbg !1096
  %3645 = and i32 %3639, 4194304, !dbg !1096
  %3646 = icmp eq i32 %3645, 0, !dbg !1096
  %is_snan934 = and i1 %is_nan933, %3646, !dbg !1096
  %3647 = bitcast float %3394 to i32, !dbg !1096
  %3648 = bitcast float %3394 to i32, !dbg !1096
  %3649 = and i32 %3648, 2139095040, !dbg !1096
  %3650 = icmp eq i32 %3649, 2139095040, !dbg !1096
  %3651 = and i32 %3648, 8388607, !dbg !1096
  %3652 = icmp ne i32 %3651, 0, !dbg !1096
  %is_nan935 = and i1 %3650, %3652, !dbg !1096
  %3653 = and i32 %3647, 4194304, !dbg !1096
  %3654 = icmp eq i32 %3653, 0, !dbg !1096
  %is_snan936 = and i1 %is_nan935, %3654, !dbg !1096
  %3655 = or i1 %is_snan934, %is_snan936, !dbg !1096
  %3656 = or i1 %3655, false, !dbg !1096
  %3657 = bitcast float %3595 to i32, !dbg !1096
  %3658 = and i32 %3657, 2147483647, !dbg !1096
  %is_zero937 = icmp eq i32 %3658, 0, !dbg !1096
  %3659 = bitcast float %3394 to i32, !dbg !1096
  %3660 = and i32 %3659, 2139095040, !dbg !1096
  %3661 = icmp eq i32 %3660, 2139095040, !dbg !1096
  %3662 = and i32 %3659, 8388607, !dbg !1096
  %3663 = icmp eq i32 %3662, 0, !dbg !1096
  %is_inf938 = and i1 %3661, %3663, !dbg !1096
  %3664 = and i1 %is_zero937, %is_inf938, !dbg !1096
  %3665 = bitcast float %3595 to i32, !dbg !1096
  %3666 = and i32 %3665, 2139095040, !dbg !1096
  %3667 = icmp eq i32 %3666, 2139095040, !dbg !1096
  %3668 = and i32 %3665, 8388607, !dbg !1096
  %3669 = icmp eq i32 %3668, 0, !dbg !1096
  %is_inf939 = and i1 %3667, %3669, !dbg !1096
  %3670 = bitcast float %3394 to i32, !dbg !1096
  %3671 = and i32 %3670, 2147483647, !dbg !1096
  %is_zero940 = icmp eq i32 %3671, 0, !dbg !1096
  %3672 = and i1 %is_inf939, %is_zero940, !dbg !1096
  %3673 = or i1 %3664, %3672, !dbg !1096
  %3674 = or i1 %3656, %3673, !dbg !1096
  br i1 %3674, label %3675, label %3677, !dbg !1096

3675:                                             ; preds = %3638
  %3676 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3677, !dbg !1096

3677:                                             ; preds = %3638, %3675
  %3678 = call float @llvm.nvvm.fma.rn.f(float %3595, float %3394, float 0x3FCEBFBD80000000) #5, !dbg !1096
  %3679 = bitcast float %3595 to i32, !dbg !1096
  %3680 = and i32 %3679, 2139095040, !dbg !1096
  %is_finite941 = icmp ne i32 %3680, 2139095040, !dbg !1096
  %3681 = and i1 true, %is_finite941, !dbg !1096
  %3682 = bitcast float %3394 to i32, !dbg !1096
  %3683 = and i32 %3682, 2139095040, !dbg !1096
  %is_finite942 = icmp ne i32 %3683, 2139095040, !dbg !1096
  %3684 = and i1 %3681, %is_finite942, !dbg !1096
  %3685 = bitcast float %3678 to i32, !dbg !1096
  %3686 = and i32 %3685, 2139095040, !dbg !1096
  %3687 = icmp eq i32 %3686, 2139095040, !dbg !1096
  %3688 = and i32 %3685, 8388607, !dbg !1096
  %3689 = icmp eq i32 %3688, 0, !dbg !1096
  %is_inf943 = and i1 %3687, %3689, !dbg !1096
  %3690 = bitcast float %3678 to i32, !dbg !1096
  %3691 = and i32 %3690, 2147483647, !dbg !1096
  %is_maxfinite944 = icmp eq i32 %3691, 2139095039, !dbg !1096
  %3692 = bitcast float %3678 to i32, !dbg !1096
  %3693 = and i32 %3692, -2147483648, !dbg !1096
  %3694 = icmp eq i32 %3693, 0, !dbg !1096
  %3695 = icmp ne i32 %3693, 0, !dbg !1096
  %is_pos_inf945 = and i1 %is_inf943, %3694, !dbg !1096
  %is_neg_inf946 = and i1 %is_inf943, %3695, !dbg !1096
  %is_pos_max947 = and i1 %is_maxfinite944, %3694, !dbg !1096
  %is_neg_max948 = and i1 %is_maxfinite944, %3695, !dbg !1096
  %overflow_cond949 = and i1 %3684, %is_inf943, !dbg !1096
  br i1 %overflow_cond949, label %3696, label %3698, !dbg !1096

3696:                                             ; preds = %3677
  %3697 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3698, !dbg !1096

3698:                                             ; preds = %3677, %3696
  %3699 = bitcast float %3595 to i32, !dbg !1096
  %3700 = and i32 %3699, 2139095040, !dbg !1096
  %3701 = icmp eq i32 %3700, 0, !dbg !1096
  %3702 = and i32 %3699, 8388607, !dbg !1096
  %3703 = icmp ne i32 %3702, 0, !dbg !1096
  %is_subnormal950 = and i1 %3701, %3703, !dbg !1096
  %3704 = xor i1 %is_subnormal950, true, !dbg !1096
  %3705 = and i1 true, %3704, !dbg !1096
  %3706 = bitcast float %3394 to i32, !dbg !1096
  %3707 = and i32 %3706, 2139095040, !dbg !1096
  %3708 = icmp eq i32 %3707, 0, !dbg !1096
  %3709 = and i32 %3706, 8388607, !dbg !1096
  %3710 = icmp ne i32 %3709, 0, !dbg !1096
  %is_subnormal951 = and i1 %3708, %3710, !dbg !1096
  %3711 = xor i1 %is_subnormal951, true, !dbg !1096
  %3712 = and i1 %3705, %3711, !dbg !1096
  %3713 = and i1 %3712, true, !dbg !1096
  %3714 = bitcast float %3678 to i32, !dbg !1096
  %3715 = and i32 %3714, 2139095040, !dbg !1096
  %3716 = icmp eq i32 %3715, 0, !dbg !1096
  %3717 = and i32 %3714, 8388607, !dbg !1096
  %3718 = icmp ne i32 %3717, 0, !dbg !1096
  %is_subnormal952 = and i1 %3716, %3718, !dbg !1096
  %is_tiny953 = or i1 %is_subnormal952, false, !dbg !1096
  %underflow_cond954 = and i1 %3713, %is_tiny953, !dbg !1096
  br i1 %underflow_cond954, label %3719, label %3721, !dbg !1096

3719:                                             ; preds = %3698
  %3720 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3721, !dbg !1096

3721:                                             ; preds = %3698, %3719
  %3722 = bitcast float %3678 to i32, !dbg !1096
  %3723 = bitcast float %3678 to i32, !dbg !1096
  %3724 = and i32 %3723, 2139095040, !dbg !1096
  %3725 = icmp eq i32 %3724, 2139095040, !dbg !1096
  %3726 = and i32 %3723, 8388607, !dbg !1096
  %3727 = icmp ne i32 %3726, 0, !dbg !1096
  %is_nan955 = and i1 %3725, %3727, !dbg !1096
  %3728 = and i32 %3722, 4194304, !dbg !1096
  %3729 = icmp eq i32 %3728, 0, !dbg !1096
  %is_snan956 = and i1 %is_nan955, %3729, !dbg !1096
  %3730 = bitcast float %3394 to i32, !dbg !1096
  %3731 = bitcast float %3394 to i32, !dbg !1096
  %3732 = and i32 %3731, 2139095040, !dbg !1096
  %3733 = icmp eq i32 %3732, 2139095040, !dbg !1096
  %3734 = and i32 %3731, 8388607, !dbg !1096
  %3735 = icmp ne i32 %3734, 0, !dbg !1096
  %is_nan957 = and i1 %3733, %3735, !dbg !1096
  %3736 = and i32 %3730, 4194304, !dbg !1096
  %3737 = icmp eq i32 %3736, 0, !dbg !1096
  %is_snan958 = and i1 %is_nan957, %3737, !dbg !1096
  %3738 = or i1 %is_snan956, %is_snan958, !dbg !1096
  %3739 = or i1 %3738, false, !dbg !1096
  %3740 = bitcast float %3678 to i32, !dbg !1096
  %3741 = and i32 %3740, 2147483647, !dbg !1096
  %is_zero959 = icmp eq i32 %3741, 0, !dbg !1096
  %3742 = bitcast float %3394 to i32, !dbg !1096
  %3743 = and i32 %3742, 2139095040, !dbg !1096
  %3744 = icmp eq i32 %3743, 2139095040, !dbg !1096
  %3745 = and i32 %3742, 8388607, !dbg !1096
  %3746 = icmp eq i32 %3745, 0, !dbg !1096
  %is_inf960 = and i1 %3744, %3746, !dbg !1096
  %3747 = and i1 %is_zero959, %is_inf960, !dbg !1096
  %3748 = bitcast float %3678 to i32, !dbg !1096
  %3749 = and i32 %3748, 2139095040, !dbg !1096
  %3750 = icmp eq i32 %3749, 2139095040, !dbg !1096
  %3751 = and i32 %3748, 8388607, !dbg !1096
  %3752 = icmp eq i32 %3751, 0, !dbg !1096
  %is_inf961 = and i1 %3750, %3752, !dbg !1096
  %3753 = bitcast float %3394 to i32, !dbg !1096
  %3754 = and i32 %3753, 2147483647, !dbg !1096
  %is_zero962 = icmp eq i32 %3754, 0, !dbg !1096
  %3755 = and i1 %is_inf961, %is_zero962, !dbg !1096
  %3756 = or i1 %3747, %3755, !dbg !1096
  %3757 = or i1 %3739, %3756, !dbg !1096
  br i1 %3757, label %3758, label %3760, !dbg !1096

3758:                                             ; preds = %3721
  %3759 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3760, !dbg !1096

3760:                                             ; preds = %3721, %3758
  %3761 = call float @llvm.nvvm.fma.rn.f(float %3678, float %3394, float 0x3FE62E4300000000) #5, !dbg !1096
  %3762 = bitcast float %3678 to i32, !dbg !1096
  %3763 = and i32 %3762, 2139095040, !dbg !1096
  %is_finite963 = icmp ne i32 %3763, 2139095040, !dbg !1096
  %3764 = and i1 true, %is_finite963, !dbg !1096
  %3765 = bitcast float %3394 to i32, !dbg !1096
  %3766 = and i32 %3765, 2139095040, !dbg !1096
  %is_finite964 = icmp ne i32 %3766, 2139095040, !dbg !1096
  %3767 = and i1 %3764, %is_finite964, !dbg !1096
  %3768 = bitcast float %3761 to i32, !dbg !1096
  %3769 = and i32 %3768, 2139095040, !dbg !1096
  %3770 = icmp eq i32 %3769, 2139095040, !dbg !1096
  %3771 = and i32 %3768, 8388607, !dbg !1096
  %3772 = icmp eq i32 %3771, 0, !dbg !1096
  %is_inf965 = and i1 %3770, %3772, !dbg !1096
  %3773 = bitcast float %3761 to i32, !dbg !1096
  %3774 = and i32 %3773, 2147483647, !dbg !1096
  %is_maxfinite966 = icmp eq i32 %3774, 2139095039, !dbg !1096
  %3775 = bitcast float %3761 to i32, !dbg !1096
  %3776 = and i32 %3775, -2147483648, !dbg !1096
  %3777 = icmp eq i32 %3776, 0, !dbg !1096
  %3778 = icmp ne i32 %3776, 0, !dbg !1096
  %is_pos_inf967 = and i1 %is_inf965, %3777, !dbg !1096
  %is_neg_inf968 = and i1 %is_inf965, %3778, !dbg !1096
  %is_pos_max969 = and i1 %is_maxfinite966, %3777, !dbg !1096
  %is_neg_max970 = and i1 %is_maxfinite966, %3778, !dbg !1096
  %overflow_cond971 = and i1 %3767, %is_inf965, !dbg !1096
  br i1 %overflow_cond971, label %3779, label %3781, !dbg !1096

3779:                                             ; preds = %3760
  %3780 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3781, !dbg !1096

3781:                                             ; preds = %3760, %3779
  %3782 = bitcast float %3678 to i32, !dbg !1096
  %3783 = and i32 %3782, 2139095040, !dbg !1096
  %3784 = icmp eq i32 %3783, 0, !dbg !1096
  %3785 = and i32 %3782, 8388607, !dbg !1096
  %3786 = icmp ne i32 %3785, 0, !dbg !1096
  %is_subnormal972 = and i1 %3784, %3786, !dbg !1096
  %3787 = xor i1 %is_subnormal972, true, !dbg !1096
  %3788 = and i1 true, %3787, !dbg !1096
  %3789 = bitcast float %3394 to i32, !dbg !1096
  %3790 = and i32 %3789, 2139095040, !dbg !1096
  %3791 = icmp eq i32 %3790, 0, !dbg !1096
  %3792 = and i32 %3789, 8388607, !dbg !1096
  %3793 = icmp ne i32 %3792, 0, !dbg !1096
  %is_subnormal973 = and i1 %3791, %3793, !dbg !1096
  %3794 = xor i1 %is_subnormal973, true, !dbg !1096
  %3795 = and i1 %3788, %3794, !dbg !1096
  %3796 = and i1 %3795, true, !dbg !1096
  %3797 = bitcast float %3761 to i32, !dbg !1096
  %3798 = and i32 %3797, 2139095040, !dbg !1096
  %3799 = icmp eq i32 %3798, 0, !dbg !1096
  %3800 = and i32 %3797, 8388607, !dbg !1096
  %3801 = icmp ne i32 %3800, 0, !dbg !1096
  %is_subnormal974 = and i1 %3799, %3801, !dbg !1096
  %is_tiny975 = or i1 %is_subnormal974, false, !dbg !1096
  %underflow_cond976 = and i1 %3796, %is_tiny975, !dbg !1096
  br i1 %underflow_cond976, label %3802, label %3804, !dbg !1096

3802:                                             ; preds = %3781
  %3803 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3804, !dbg !1096

3804:                                             ; preds = %3781, %3802
  %3805 = bitcast float %3761 to i32, !dbg !1096
  %3806 = bitcast float %3761 to i32, !dbg !1096
  %3807 = and i32 %3806, 2139095040, !dbg !1096
  %3808 = icmp eq i32 %3807, 2139095040, !dbg !1096
  %3809 = and i32 %3806, 8388607, !dbg !1096
  %3810 = icmp ne i32 %3809, 0, !dbg !1096
  %is_nan977 = and i1 %3808, %3810, !dbg !1096
  %3811 = and i32 %3805, 4194304, !dbg !1096
  %3812 = icmp eq i32 %3811, 0, !dbg !1096
  %is_snan978 = and i1 %is_nan977, %3812, !dbg !1096
  %3813 = bitcast float %3394 to i32, !dbg !1096
  %3814 = bitcast float %3394 to i32, !dbg !1096
  %3815 = and i32 %3814, 2139095040, !dbg !1096
  %3816 = icmp eq i32 %3815, 2139095040, !dbg !1096
  %3817 = and i32 %3814, 8388607, !dbg !1096
  %3818 = icmp ne i32 %3817, 0, !dbg !1096
  %is_nan979 = and i1 %3816, %3818, !dbg !1096
  %3819 = and i32 %3813, 4194304, !dbg !1096
  %3820 = icmp eq i32 %3819, 0, !dbg !1096
  %is_snan980 = and i1 %is_nan979, %3820, !dbg !1096
  %3821 = or i1 %is_snan978, %is_snan980, !dbg !1096
  %3822 = or i1 %3821, false, !dbg !1096
  %3823 = bitcast float %3761 to i32, !dbg !1096
  %3824 = and i32 %3823, 2147483647, !dbg !1096
  %is_zero981 = icmp eq i32 %3824, 0, !dbg !1096
  %3825 = bitcast float %3394 to i32, !dbg !1096
  %3826 = and i32 %3825, 2139095040, !dbg !1096
  %3827 = icmp eq i32 %3826, 2139095040, !dbg !1096
  %3828 = and i32 %3825, 8388607, !dbg !1096
  %3829 = icmp eq i32 %3828, 0, !dbg !1096
  %is_inf982 = and i1 %3827, %3829, !dbg !1096
  %3830 = and i1 %is_zero981, %is_inf982, !dbg !1096
  %3831 = bitcast float %3761 to i32, !dbg !1096
  %3832 = and i32 %3831, 2139095040, !dbg !1096
  %3833 = icmp eq i32 %3832, 2139095040, !dbg !1096
  %3834 = and i32 %3831, 8388607, !dbg !1096
  %3835 = icmp eq i32 %3834, 0, !dbg !1096
  %is_inf983 = and i1 %3833, %3835, !dbg !1096
  %3836 = bitcast float %3394 to i32, !dbg !1096
  %3837 = and i32 %3836, 2147483647, !dbg !1096
  %is_zero984 = icmp eq i32 %3837, 0, !dbg !1096
  %3838 = and i1 %is_inf983, %is_zero984, !dbg !1096
  %3839 = or i1 %3830, %3838, !dbg !1096
  %3840 = or i1 %3822, %3839, !dbg !1096
  br i1 %3840, label %3841, label %3843, !dbg !1096

3841:                                             ; preds = %3804
  %3842 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3843, !dbg !1096

3843:                                             ; preds = %3804, %3841
  %3844 = call float @llvm.nvvm.fma.rn.f(float %3761, float %3394, float 1.000000e+00) #5, !dbg !1096
  %3845 = bitcast float %3761 to i32, !dbg !1096
  %3846 = and i32 %3845, 2139095040, !dbg !1096
  %is_finite985 = icmp ne i32 %3846, 2139095040, !dbg !1096
  %3847 = and i1 true, %is_finite985, !dbg !1096
  %3848 = bitcast float %3394 to i32, !dbg !1096
  %3849 = and i32 %3848, 2139095040, !dbg !1096
  %is_finite986 = icmp ne i32 %3849, 2139095040, !dbg !1096
  %3850 = and i1 %3847, %is_finite986, !dbg !1096
  %3851 = bitcast float %3844 to i32, !dbg !1096
  %3852 = and i32 %3851, 2139095040, !dbg !1096
  %3853 = icmp eq i32 %3852, 2139095040, !dbg !1096
  %3854 = and i32 %3851, 8388607, !dbg !1096
  %3855 = icmp eq i32 %3854, 0, !dbg !1096
  %is_inf987 = and i1 %3853, %3855, !dbg !1096
  %3856 = bitcast float %3844 to i32, !dbg !1096
  %3857 = and i32 %3856, 2147483647, !dbg !1096
  %is_maxfinite988 = icmp eq i32 %3857, 2139095039, !dbg !1096
  %3858 = bitcast float %3844 to i32, !dbg !1096
  %3859 = and i32 %3858, -2147483648, !dbg !1096
  %3860 = icmp eq i32 %3859, 0, !dbg !1096
  %3861 = icmp ne i32 %3859, 0, !dbg !1096
  %is_pos_inf989 = and i1 %is_inf987, %3860, !dbg !1096
  %is_neg_inf990 = and i1 %is_inf987, %3861, !dbg !1096
  %is_pos_max991 = and i1 %is_maxfinite988, %3860, !dbg !1096
  %is_neg_max992 = and i1 %is_maxfinite988, %3861, !dbg !1096
  %overflow_cond993 = and i1 %3850, %is_inf987, !dbg !1096
  br i1 %overflow_cond993, label %3862, label %3864, !dbg !1096

3862:                                             ; preds = %3843
  %3863 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3864, !dbg !1096

3864:                                             ; preds = %3843, %3862
  %3865 = bitcast float %3761 to i32, !dbg !1096
  %3866 = and i32 %3865, 2139095040, !dbg !1096
  %3867 = icmp eq i32 %3866, 0, !dbg !1096
  %3868 = and i32 %3865, 8388607, !dbg !1096
  %3869 = icmp ne i32 %3868, 0, !dbg !1096
  %is_subnormal994 = and i1 %3867, %3869, !dbg !1096
  %3870 = xor i1 %is_subnormal994, true, !dbg !1096
  %3871 = and i1 true, %3870, !dbg !1096
  %3872 = bitcast float %3394 to i32, !dbg !1096
  %3873 = and i32 %3872, 2139095040, !dbg !1096
  %3874 = icmp eq i32 %3873, 0, !dbg !1096
  %3875 = and i32 %3872, 8388607, !dbg !1096
  %3876 = icmp ne i32 %3875, 0, !dbg !1096
  %is_subnormal995 = and i1 %3874, %3876, !dbg !1096
  %3877 = xor i1 %is_subnormal995, true, !dbg !1096
  %3878 = and i1 %3871, %3877, !dbg !1096
  %3879 = and i1 %3878, true, !dbg !1096
  %3880 = bitcast float %3844 to i32, !dbg !1096
  %3881 = and i32 %3880, 2139095040, !dbg !1096
  %3882 = icmp eq i32 %3881, 0, !dbg !1096
  %3883 = and i32 %3880, 8388607, !dbg !1096
  %3884 = icmp ne i32 %3883, 0, !dbg !1096
  %is_subnormal996 = and i1 %3882, %3884, !dbg !1096
  %is_tiny997 = or i1 %is_subnormal996, false, !dbg !1096
  %underflow_cond998 = and i1 %3879, %is_tiny997, !dbg !1096
  br i1 %underflow_cond998, label %3885, label %3887, !dbg !1096

3885:                                             ; preds = %3864
  %3886 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3887, !dbg !1096

3887:                                             ; preds = %3864, %3885
  %3888 = fptosi float %3296 to i32, !dbg !1096
  %3889 = fcmp ogt float %3296, 0.000000e+00, !dbg !1096
  %3890 = select i1 %3889, i32 0, i32 -2097152000, !dbg !1096
  %3891 = add i32 2130706432, %3890, !dbg !1096
  %3892 = bitcast i32 %3891 to float, !dbg !1096
  %3893 = bitcast float %3844 to i32, !dbg !1096
  %3894 = bitcast float %3844 to i32, !dbg !1096
  %3895 = and i32 %3894, 2139095040, !dbg !1096
  %3896 = icmp eq i32 %3895, 2139095040, !dbg !1096
  %3897 = and i32 %3894, 8388607, !dbg !1096
  %3898 = icmp ne i32 %3897, 0, !dbg !1096
  %is_nan999 = and i1 %3896, %3898, !dbg !1096
  %3899 = and i32 %3893, 4194304, !dbg !1096
  %3900 = icmp eq i32 %3899, 0, !dbg !1096
  %is_snan1000 = and i1 %is_nan999, %3900, !dbg !1096
  %3901 = bitcast float %3892 to i32, !dbg !1096
  %3902 = bitcast float %3892 to i32, !dbg !1096
  %3903 = and i32 %3902, 2139095040, !dbg !1096
  %3904 = icmp eq i32 %3903, 2139095040, !dbg !1096
  %3905 = and i32 %3902, 8388607, !dbg !1096
  %3906 = icmp ne i32 %3905, 0, !dbg !1096
  %is_nan1001 = and i1 %3904, %3906, !dbg !1096
  %3907 = and i32 %3901, 4194304, !dbg !1096
  %3908 = icmp eq i32 %3907, 0, !dbg !1096
  %is_snan1002 = and i1 %is_nan1001, %3908, !dbg !1096
  %3909 = or i1 %is_snan1000, %is_snan1002, !dbg !1096
  %3910 = bitcast float %3844 to i32, !dbg !1096
  %3911 = and i32 %3910, 2147483647, !dbg !1096
  %is_zero1003 = icmp eq i32 %3911, 0, !dbg !1096
  %3912 = bitcast float %3892 to i32, !dbg !1096
  %3913 = and i32 %3912, 2139095040, !dbg !1096
  %3914 = icmp eq i32 %3913, 2139095040, !dbg !1096
  %3915 = and i32 %3912, 8388607, !dbg !1096
  %3916 = icmp eq i32 %3915, 0, !dbg !1096
  %is_inf1004 = and i1 %3914, %3916, !dbg !1096
  %3917 = and i1 %is_zero1003, %is_inf1004, !dbg !1096
  %3918 = bitcast float %3844 to i32, !dbg !1096
  %3919 = and i32 %3918, 2139095040, !dbg !1096
  %3920 = icmp eq i32 %3919, 2139095040, !dbg !1096
  %3921 = and i32 %3918, 8388607, !dbg !1096
  %3922 = icmp eq i32 %3921, 0, !dbg !1096
  %is_inf1005 = and i1 %3920, %3922, !dbg !1096
  %3923 = bitcast float %3892 to i32, !dbg !1096
  %3924 = and i32 %3923, 2147483647, !dbg !1096
  %is_zero1006 = icmp eq i32 %3924, 0, !dbg !1096
  %3925 = and i1 %is_inf1005, %is_zero1006, !dbg !1096
  %3926 = or i1 %3917, %3925, !dbg !1096
  %3927 = or i1 %3909, %3926, !dbg !1096
  br i1 %3927, label %3928, label %3930, !dbg !1096

3928:                                             ; preds = %3887
  %3929 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3930, !dbg !1096

3930:                                             ; preds = %3887, %3928
  %3931 = fmul float %3844, %3892, !dbg !1096
  %3932 = bitcast float %3844 to i32, !dbg !1096
  %3933 = and i32 %3932, 2139095040, !dbg !1096
  %is_finite1007 = icmp ne i32 %3933, 2139095040, !dbg !1096
  %3934 = and i1 true, %is_finite1007, !dbg !1096
  %3935 = bitcast float %3892 to i32, !dbg !1096
  %3936 = and i32 %3935, 2139095040, !dbg !1096
  %is_finite1008 = icmp ne i32 %3936, 2139095040, !dbg !1096
  %3937 = and i1 %3934, %is_finite1008, !dbg !1096
  %3938 = bitcast float %3931 to i32, !dbg !1096
  %3939 = and i32 %3938, 2139095040, !dbg !1096
  %3940 = icmp eq i32 %3939, 2139095040, !dbg !1096
  %3941 = and i32 %3938, 8388607, !dbg !1096
  %3942 = icmp eq i32 %3941, 0, !dbg !1096
  %is_inf1009 = and i1 %3940, %3942, !dbg !1096
  %3943 = bitcast float %3931 to i32, !dbg !1096
  %3944 = and i32 %3943, 2147483647, !dbg !1096
  %is_maxfinite1010 = icmp eq i32 %3944, 2139095039, !dbg !1096
  %3945 = bitcast float %3931 to i32, !dbg !1096
  %3946 = and i32 %3945, -2147483648, !dbg !1096
  %3947 = icmp eq i32 %3946, 0, !dbg !1096
  %3948 = icmp ne i32 %3946, 0, !dbg !1096
  %is_pos_inf1011 = and i1 %is_inf1009, %3947, !dbg !1096
  %is_neg_inf1012 = and i1 %is_inf1009, %3948, !dbg !1096
  %is_pos_max1013 = and i1 %is_maxfinite1010, %3947, !dbg !1096
  %is_neg_max1014 = and i1 %is_maxfinite1010, %3948, !dbg !1096
  %overflow_cond1015 = and i1 %3937, %is_inf1009, !dbg !1096
  br i1 %overflow_cond1015, label %3949, label %3951, !dbg !1096

3949:                                             ; preds = %3930
  %3950 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3951, !dbg !1096

3951:                                             ; preds = %3930, %3949
  %3952 = bitcast float %3844 to i32, !dbg !1096
  %3953 = and i32 %3952, 2139095040, !dbg !1096
  %3954 = icmp eq i32 %3953, 0, !dbg !1096
  %3955 = and i32 %3952, 8388607, !dbg !1096
  %3956 = icmp ne i32 %3955, 0, !dbg !1096
  %is_subnormal1016 = and i1 %3954, %3956, !dbg !1096
  %3957 = xor i1 %is_subnormal1016, true, !dbg !1096
  %3958 = and i1 true, %3957, !dbg !1096
  %3959 = bitcast float %3892 to i32, !dbg !1096
  %3960 = and i32 %3959, 2139095040, !dbg !1096
  %3961 = icmp eq i32 %3960, 0, !dbg !1096
  %3962 = and i32 %3959, 8388607, !dbg !1096
  %3963 = icmp ne i32 %3962, 0, !dbg !1096
  %is_subnormal1017 = and i1 %3961, %3963, !dbg !1096
  %3964 = xor i1 %is_subnormal1017, true, !dbg !1096
  %3965 = and i1 %3958, %3964, !dbg !1096
  %3966 = bitcast float %3931 to i32, !dbg !1096
  %3967 = and i32 %3966, 2139095040, !dbg !1096
  %3968 = icmp eq i32 %3967, 0, !dbg !1096
  %3969 = and i32 %3966, 8388607, !dbg !1096
  %3970 = icmp ne i32 %3969, 0, !dbg !1096
  %is_subnormal1018 = and i1 %3968, %3970, !dbg !1096
  %3971 = bitcast float %3931 to i32, !dbg !1096
  %3972 = and i32 %3971, 2147483647, !dbg !1096
  %is_zero1019 = icmp eq i32 %3972, 0, !dbg !1096
  %3973 = bitcast float %3844 to i32, !dbg !1096
  %3974 = and i32 %3973, 2147483647, !dbg !1096
  %is_zero1020 = icmp eq i32 %3974, 0, !dbg !1096
  %3975 = xor i1 %is_zero1020, true, !dbg !1096
  %3976 = bitcast float %3892 to i32, !dbg !1096
  %3977 = and i32 %3976, 2147483647, !dbg !1096
  %is_zero1021 = icmp eq i32 %3977, 0, !dbg !1096
  %3978 = xor i1 %is_zero1021, true, !dbg !1096
  %3979 = and i1 %3975, %3978, !dbg !1096
  %3980 = and i1 %is_zero1019, %3979, !dbg !1096
  %is_tiny1022 = or i1 %is_subnormal1018, %3980, !dbg !1096
  %underflow_cond1023 = and i1 %3965, %is_tiny1022, !dbg !1096
  br i1 %underflow_cond1023, label %3981, label %3983, !dbg !1096

3981:                                             ; preds = %3951
  %3982 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %3983, !dbg !1096

3983:                                             ; preds = %3951, %3981
  %3984 = shl i32 %3888, 23, !dbg !1096
  %3985 = sub i32 %3984, %3890, !dbg !1096
  %3986 = bitcast i32 %3985 to float, !dbg !1096
  %3987 = bitcast float %3931 to i32, !dbg !1096
  %3988 = bitcast float %3931 to i32, !dbg !1096
  %3989 = and i32 %3988, 2139095040, !dbg !1096
  %3990 = icmp eq i32 %3989, 2139095040, !dbg !1096
  %3991 = and i32 %3988, 8388607, !dbg !1096
  %3992 = icmp ne i32 %3991, 0, !dbg !1096
  %is_nan1024 = and i1 %3990, %3992, !dbg !1096
  %3993 = and i32 %3987, 4194304, !dbg !1096
  %3994 = icmp eq i32 %3993, 0, !dbg !1096
  %is_snan1025 = and i1 %is_nan1024, %3994, !dbg !1096
  %3995 = bitcast float %3986 to i32, !dbg !1096
  %3996 = bitcast float %3986 to i32, !dbg !1096
  %3997 = and i32 %3996, 2139095040, !dbg !1096
  %3998 = icmp eq i32 %3997, 2139095040, !dbg !1096
  %3999 = and i32 %3996, 8388607, !dbg !1096
  %4000 = icmp ne i32 %3999, 0, !dbg !1096
  %is_nan1026 = and i1 %3998, %4000, !dbg !1096
  %4001 = and i32 %3995, 4194304, !dbg !1096
  %4002 = icmp eq i32 %4001, 0, !dbg !1096
  %is_snan1027 = and i1 %is_nan1026, %4002, !dbg !1096
  %4003 = or i1 %is_snan1025, %is_snan1027, !dbg !1096
  %4004 = bitcast float %3931 to i32, !dbg !1096
  %4005 = and i32 %4004, 2147483647, !dbg !1096
  %is_zero1028 = icmp eq i32 %4005, 0, !dbg !1096
  %4006 = bitcast float %3986 to i32, !dbg !1096
  %4007 = and i32 %4006, 2139095040, !dbg !1096
  %4008 = icmp eq i32 %4007, 2139095040, !dbg !1096
  %4009 = and i32 %4006, 8388607, !dbg !1096
  %4010 = icmp eq i32 %4009, 0, !dbg !1096
  %is_inf1029 = and i1 %4008, %4010, !dbg !1096
  %4011 = and i1 %is_zero1028, %is_inf1029, !dbg !1096
  %4012 = bitcast float %3931 to i32, !dbg !1096
  %4013 = and i32 %4012, 2139095040, !dbg !1096
  %4014 = icmp eq i32 %4013, 2139095040, !dbg !1096
  %4015 = and i32 %4012, 8388607, !dbg !1096
  %4016 = icmp eq i32 %4015, 0, !dbg !1096
  %is_inf1030 = and i1 %4014, %4016, !dbg !1096
  %4017 = bitcast float %3986 to i32, !dbg !1096
  %4018 = and i32 %4017, 2147483647, !dbg !1096
  %is_zero1031 = icmp eq i32 %4018, 0, !dbg !1096
  %4019 = and i1 %is_inf1030, %is_zero1031, !dbg !1096
  %4020 = or i1 %4011, %4019, !dbg !1096
  %4021 = or i1 %4003, %4020, !dbg !1096
  br i1 %4021, label %4022, label %4024, !dbg !1096

4022:                                             ; preds = %3983
  %4023 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %4024, !dbg !1096

4024:                                             ; preds = %3983, %4022
  %4025 = fmul float %3931, %3986, !dbg !1096
  %4026 = bitcast float %3931 to i32, !dbg !1096
  %4027 = and i32 %4026, 2139095040, !dbg !1096
  %is_finite1032 = icmp ne i32 %4027, 2139095040, !dbg !1096
  %4028 = and i1 true, %is_finite1032, !dbg !1096
  %4029 = bitcast float %3986 to i32, !dbg !1096
  %4030 = and i32 %4029, 2139095040, !dbg !1096
  %is_finite1033 = icmp ne i32 %4030, 2139095040, !dbg !1096
  %4031 = and i1 %4028, %is_finite1033, !dbg !1096
  %4032 = bitcast float %4025 to i32, !dbg !1096
  %4033 = and i32 %4032, 2139095040, !dbg !1096
  %4034 = icmp eq i32 %4033, 2139095040, !dbg !1096
  %4035 = and i32 %4032, 8388607, !dbg !1096
  %4036 = icmp eq i32 %4035, 0, !dbg !1096
  %is_inf1034 = and i1 %4034, %4036, !dbg !1096
  %4037 = bitcast float %4025 to i32, !dbg !1096
  %4038 = and i32 %4037, 2147483647, !dbg !1096
  %is_maxfinite1035 = icmp eq i32 %4038, 2139095039, !dbg !1096
  %4039 = bitcast float %4025 to i32, !dbg !1096
  %4040 = and i32 %4039, -2147483648, !dbg !1096
  %4041 = icmp eq i32 %4040, 0, !dbg !1096
  %4042 = icmp ne i32 %4040, 0, !dbg !1096
  %is_pos_inf1036 = and i1 %is_inf1034, %4041, !dbg !1096
  %is_neg_inf1037 = and i1 %is_inf1034, %4042, !dbg !1096
  %is_pos_max1038 = and i1 %is_maxfinite1035, %4041, !dbg !1096
  %is_neg_max1039 = and i1 %is_maxfinite1035, %4042, !dbg !1096
  %overflow_cond1040 = and i1 %4031, %is_inf1034, !dbg !1096
  br i1 %overflow_cond1040, label %4043, label %4045, !dbg !1096

4043:                                             ; preds = %4024
  %4044 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %4045, !dbg !1096

4045:                                             ; preds = %4024, %4043
  %4046 = bitcast float %3931 to i32, !dbg !1096
  %4047 = and i32 %4046, 2139095040, !dbg !1096
  %4048 = icmp eq i32 %4047, 0, !dbg !1096
  %4049 = and i32 %4046, 8388607, !dbg !1096
  %4050 = icmp ne i32 %4049, 0, !dbg !1096
  %is_subnormal1041 = and i1 %4048, %4050, !dbg !1096
  %4051 = xor i1 %is_subnormal1041, true, !dbg !1096
  %4052 = and i1 true, %4051, !dbg !1096
  %4053 = bitcast float %3986 to i32, !dbg !1096
  %4054 = and i32 %4053, 2139095040, !dbg !1096
  %4055 = icmp eq i32 %4054, 0, !dbg !1096
  %4056 = and i32 %4053, 8388607, !dbg !1096
  %4057 = icmp ne i32 %4056, 0, !dbg !1096
  %is_subnormal1042 = and i1 %4055, %4057, !dbg !1096
  %4058 = xor i1 %is_subnormal1042, true, !dbg !1096
  %4059 = and i1 %4052, %4058, !dbg !1096
  %4060 = bitcast float %4025 to i32, !dbg !1096
  %4061 = and i32 %4060, 2139095040, !dbg !1096
  %4062 = icmp eq i32 %4061, 0, !dbg !1096
  %4063 = and i32 %4060, 8388607, !dbg !1096
  %4064 = icmp ne i32 %4063, 0, !dbg !1096
  %is_subnormal1043 = and i1 %4062, %4064, !dbg !1096
  %4065 = bitcast float %4025 to i32, !dbg !1096
  %4066 = and i32 %4065, 2147483647, !dbg !1096
  %is_zero1044 = icmp eq i32 %4066, 0, !dbg !1096
  %4067 = bitcast float %3931 to i32, !dbg !1096
  %4068 = and i32 %4067, 2147483647, !dbg !1096
  %is_zero1045 = icmp eq i32 %4068, 0, !dbg !1096
  %4069 = xor i1 %is_zero1045, true, !dbg !1096
  %4070 = bitcast float %3986 to i32, !dbg !1096
  %4071 = and i32 %4070, 2147483647, !dbg !1096
  %is_zero1046 = icmp eq i32 %4071, 0, !dbg !1096
  %4072 = xor i1 %is_zero1046, true, !dbg !1096
  %4073 = and i1 %4069, %4072, !dbg !1096
  %4074 = and i1 %is_zero1044, %4073, !dbg !1096
  %is_tiny1047 = or i1 %is_subnormal1043, %4074, !dbg !1096
  %underflow_cond1048 = and i1 %4059, %is_tiny1047, !dbg !1096
  br i1 %underflow_cond1048, label %4075, label %4077, !dbg !1096

4075:                                             ; preds = %4045
  %4076 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %4077, !dbg !1096

4077:                                             ; preds = %4045, %4075
  %4078 = call float @llvm.nvvm.fabs.f32(float %3008), !dbg !1096
  %4079 = fcmp ogt float %4078, 1.520000e+02, !dbg !1096
  br i1 %4079, label %4080, label %__internal_accurate_powf.exit.i, !dbg !1096

4080:                                             ; preds = %4077
  %4081 = fcmp olt float %3008, 0.000000e+00, !dbg !1096
  br i1 %4081, label %4082, label %4083, !dbg !1096

4082:                                             ; preds = %4080
  br label %4084, !dbg !1096

4083:                                             ; preds = %4080
  br label %4084, !dbg !1096

4084:                                             ; preds = %4083, %4082
  %4085 = phi float [ 0.000000e+00, %4082 ], [ 0x7FF0000000000000, %4083 ], !dbg !1096
  br label %__internal_accurate_powf.exit.i, !dbg !1096

__internal_accurate_powf.exit.i:                  ; preds = %4084, %4077
  %t.i.0.i = phi float [ %4085, %4084 ], [ %4025, %4077 ], !dbg !1096
  %4086 = fcmp oeq float %762, 1.000000e+00, !dbg !1096
  br i1 %4086, label %4089, label %4087, !dbg !1096

4087:                                             ; preds = %__internal_accurate_powf.exit.i
  %4088 = fcmp oeq float %763, 0.000000e+00, !dbg !1096
  br i1 %4088, label %4089, label %4090, !dbg !1096

4089:                                             ; preds = %4087, %__internal_accurate_powf.exit.i
  br label %__nv_powf.exit, !dbg !1096

4090:                                             ; preds = %4087
  %4091 = call float @llvm.nvvm.fabs.f32(float %762), !dbg !1096
  %4092 = fcmp ole float %4091, 0x7FF0000000000000, !dbg !1096
  %4093 = xor i1 %4092, true, !dbg !1096
  %4094 = select i1 %4093, i32 1, i32 0, !dbg !1096
  br i1 %4093, label %4100, label %4095, !dbg !1096

4095:                                             ; preds = %4090
  %4096 = call float @llvm.nvvm.fabs.f32(float %763), !dbg !1096
  %4097 = fcmp ole float %4096, 0x7FF0000000000000, !dbg !1096
  %4098 = xor i1 %4097, true, !dbg !1096
  %4099 = select i1 %4098, i32 1, i32 0, !dbg !1096
  br i1 %4098, label %4100, label %4160, !dbg !1096

4100:                                             ; preds = %4095, %4090
  %4101 = bitcast float %762 to i32, !dbg !1096
  %4102 = bitcast float %762 to i32, !dbg !1096
  %4103 = and i32 %4102, 2139095040, !dbg !1096
  %4104 = icmp eq i32 %4103, 2139095040, !dbg !1096
  %4105 = and i32 %4102, 8388607, !dbg !1096
  %4106 = icmp ne i32 %4105, 0, !dbg !1096
  %is_nan1049 = and i1 %4104, %4106, !dbg !1096
  %4107 = and i32 %4101, 4194304, !dbg !1096
  %4108 = icmp eq i32 %4107, 0, !dbg !1096
  %is_snan1050 = and i1 %is_nan1049, %4108, !dbg !1096
  %4109 = bitcast float %763 to i32, !dbg !1096
  %4110 = bitcast float %763 to i32, !dbg !1096
  %4111 = and i32 %4110, 2139095040, !dbg !1096
  %4112 = icmp eq i32 %4111, 2139095040, !dbg !1096
  %4113 = and i32 %4110, 8388607, !dbg !1096
  %4114 = icmp ne i32 %4113, 0, !dbg !1096
  %is_nan1051 = and i1 %4112, %4114, !dbg !1096
  %4115 = and i32 %4109, 4194304, !dbg !1096
  %4116 = icmp eq i32 %4115, 0, !dbg !1096
  %is_snan1052 = and i1 %is_nan1051, %4116, !dbg !1096
  %4117 = or i1 %is_snan1050, %is_snan1052, !dbg !1096
  %4118 = bitcast float %762 to i32, !dbg !1096
  %4119 = and i32 %4118, 2139095040, !dbg !1096
  %4120 = icmp eq i32 %4119, 2139095040, !dbg !1096
  %4121 = and i32 %4118, 8388607, !dbg !1096
  %4122 = icmp eq i32 %4121, 0, !dbg !1096
  %is_inf1053 = and i1 %4120, %4122, !dbg !1096
  %4123 = bitcast float %763 to i32, !dbg !1096
  %4124 = and i32 %4123, 2139095040, !dbg !1096
  %4125 = icmp eq i32 %4124, 2139095040, !dbg !1096
  %4126 = and i32 %4123, 8388607, !dbg !1096
  %4127 = icmp eq i32 %4126, 0, !dbg !1096
  %is_inf1054 = and i1 %4125, %4127, !dbg !1096
  %4128 = and i1 %is_inf1053, %is_inf1054, !dbg !1096
  %4129 = bitcast float %762 to i32, !dbg !1096
  %4130 = bitcast float %763 to i32, !dbg !1096
  %4131 = and i32 %4129, -2147483648, !dbg !1096
  %4132 = and i32 %4130, -2147483648, !dbg !1096
  %4133 = icmp ne i32 %4131, %4132, !dbg !1096
  %4134 = and i1 %4128, %4133, !dbg !1096
  %4135 = or i1 %4117, %4134, !dbg !1096
  br i1 %4135, label %4136, label %4138, !dbg !1096

4136:                                             ; preds = %4100
  %4137 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %4138, !dbg !1096

4138:                                             ; preds = %4100, %4136
  %4139 = call float @llvm.nvvm.add.rn.f(float %762, float %763) #5, !dbg !1096
  %4140 = bitcast float %762 to i32, !dbg !1096
  %4141 = and i32 %4140, 2139095040, !dbg !1096
  %is_finite1055 = icmp ne i32 %4141, 2139095040, !dbg !1096
  %4142 = and i1 true, %is_finite1055, !dbg !1096
  %4143 = bitcast float %763 to i32, !dbg !1096
  %4144 = and i32 %4143, 2139095040, !dbg !1096
  %is_finite1056 = icmp ne i32 %4144, 2139095040, !dbg !1096
  %4145 = and i1 %4142, %is_finite1056, !dbg !1096
  %4146 = bitcast float %4139 to i32, !dbg !1096
  %4147 = and i32 %4146, 2139095040, !dbg !1096
  %4148 = icmp eq i32 %4147, 2139095040, !dbg !1096
  %4149 = and i32 %4146, 8388607, !dbg !1096
  %4150 = icmp eq i32 %4149, 0, !dbg !1096
  %is_inf1057 = and i1 %4148, %4150, !dbg !1096
  %4151 = bitcast float %4139 to i32, !dbg !1096
  %4152 = and i32 %4151, 2147483647, !dbg !1096
  %is_maxfinite1058 = icmp eq i32 %4152, 2139095039, !dbg !1096
  %4153 = bitcast float %4139 to i32, !dbg !1096
  %4154 = and i32 %4153, -2147483648, !dbg !1096
  %4155 = icmp eq i32 %4154, 0, !dbg !1096
  %4156 = icmp ne i32 %4154, 0, !dbg !1096
  %is_pos_inf1059 = and i1 %is_inf1057, %4155, !dbg !1096
  %is_neg_inf1060 = and i1 %is_inf1057, %4156, !dbg !1096
  %is_pos_max1061 = and i1 %is_maxfinite1058, %4155, !dbg !1096
  %is_neg_max1062 = and i1 %is_maxfinite1058, %4156, !dbg !1096
  %overflow_cond1063 = and i1 %4145, %is_inf1057, !dbg !1096
  br i1 %overflow_cond1063, label %4157, label %4159, !dbg !1096

4157:                                             ; preds = %4138
  %4158 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %4159, !dbg !1096

4159:                                             ; preds = %4138, %4157
  br label %4296, !dbg !1096

4160:                                             ; preds = %4095
  %4161 = fcmp oeq float %762, 0.000000e+00, !dbg !1096
  br i1 %4161, label %4166, label %4162, !dbg !1096

4162:                                             ; preds = %4160
  %4163 = call float @llvm.nvvm.fabs.f32(float %762), !dbg !1096
  %4164 = fcmp oeq float %4163, 0x7FF0000000000000, !dbg !1096
  %4165 = select i1 %4164, i32 1, i32 0, !dbg !1096
  br i1 %4164, label %4166, label %4236, !dbg !1096

4166:                                             ; preds = %4162, %4160
  %4167 = bitcast float %762 to i32, !dbg !1096
  %4168 = bitcast float %762 to i32, !dbg !1096
  %4169 = and i32 %4168, 2139095040, !dbg !1096
  %4170 = icmp eq i32 %4169, 2139095040, !dbg !1096
  %4171 = and i32 %4168, 8388607, !dbg !1096
  %4172 = icmp ne i32 %4171, 0, !dbg !1096
  %is_nan1064 = and i1 %4170, %4172, !dbg !1096
  %4173 = and i32 %4167, 4194304, !dbg !1096
  %4174 = icmp eq i32 %4173, 0, !dbg !1096
  %is_snan1065 = and i1 %is_nan1064, %4174, !dbg !1096
  %4175 = bitcast float %762 to i32, !dbg !1096
  %4176 = bitcast float %762 to i32, !dbg !1096
  %4177 = and i32 %4176, 2139095040, !dbg !1096
  %4178 = icmp eq i32 %4177, 2139095040, !dbg !1096
  %4179 = and i32 %4176, 8388607, !dbg !1096
  %4180 = icmp ne i32 %4179, 0, !dbg !1096
  %is_nan1066 = and i1 %4178, %4180, !dbg !1096
  %4181 = and i32 %4175, 4194304, !dbg !1096
  %4182 = icmp eq i32 %4181, 0, !dbg !1096
  %is_snan1067 = and i1 %is_nan1066, %4182, !dbg !1096
  %4183 = or i1 %is_snan1065, %is_snan1067, !dbg !1096
  %4184 = bitcast float %762 to i32, !dbg !1096
  %4185 = and i32 %4184, 2139095040, !dbg !1096
  %4186 = icmp eq i32 %4185, 2139095040, !dbg !1096
  %4187 = and i32 %4184, 8388607, !dbg !1096
  %4188 = icmp eq i32 %4187, 0, !dbg !1096
  %is_inf1068 = and i1 %4186, %4188, !dbg !1096
  %4189 = bitcast float %762 to i32, !dbg !1096
  %4190 = and i32 %4189, 2139095040, !dbg !1096
  %4191 = icmp eq i32 %4190, 2139095040, !dbg !1096
  %4192 = and i32 %4189, 8388607, !dbg !1096
  %4193 = icmp eq i32 %4192, 0, !dbg !1096
  %is_inf1069 = and i1 %4191, %4193, !dbg !1096
  %4194 = and i1 %is_inf1068, %is_inf1069, !dbg !1096
  %4195 = bitcast float %762 to i32, !dbg !1096
  %4196 = bitcast float %762 to i32, !dbg !1096
  %4197 = and i32 %4195, -2147483648, !dbg !1096
  %4198 = and i32 %4196, -2147483648, !dbg !1096
  %4199 = icmp ne i32 %4197, %4198, !dbg !1096
  %4200 = and i1 %4194, %4199, !dbg !1096
  %4201 = or i1 %4183, %4200, !dbg !1096
  br i1 %4201, label %4202, label %4204, !dbg !1096

4202:                                             ; preds = %4166
  %4203 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %4204, !dbg !1096

4204:                                             ; preds = %4166, %4202
  %4205 = fadd float %762, %762, !dbg !1096
  %4206 = bitcast float %762 to i32, !dbg !1096
  %4207 = and i32 %4206, 2139095040, !dbg !1096
  %is_finite1070 = icmp ne i32 %4207, 2139095040, !dbg !1096
  %4208 = and i1 true, %is_finite1070, !dbg !1096
  %4209 = bitcast float %762 to i32, !dbg !1096
  %4210 = and i32 %4209, 2139095040, !dbg !1096
  %is_finite1071 = icmp ne i32 %4210, 2139095040, !dbg !1096
  %4211 = and i1 %4208, %is_finite1071, !dbg !1096
  %4212 = bitcast float %4205 to i32, !dbg !1096
  %4213 = and i32 %4212, 2139095040, !dbg !1096
  %4214 = icmp eq i32 %4213, 2139095040, !dbg !1096
  %4215 = and i32 %4212, 8388607, !dbg !1096
  %4216 = icmp eq i32 %4215, 0, !dbg !1096
  %is_inf1072 = and i1 %4214, %4216, !dbg !1096
  %4217 = bitcast float %4205 to i32, !dbg !1096
  %4218 = and i32 %4217, 2147483647, !dbg !1096
  %is_maxfinite1073 = icmp eq i32 %4218, 2139095039, !dbg !1096
  %4219 = bitcast float %4205 to i32, !dbg !1096
  %4220 = and i32 %4219, -2147483648, !dbg !1096
  %4221 = icmp eq i32 %4220, 0, !dbg !1096
  %4222 = icmp ne i32 %4220, 0, !dbg !1096
  %is_pos_inf1074 = and i1 %is_inf1072, %4221, !dbg !1096
  %is_neg_inf1075 = and i1 %is_inf1072, %4222, !dbg !1096
  %is_pos_max1076 = and i1 %is_maxfinite1073, %4221, !dbg !1096
  %is_neg_max1077 = and i1 %is_maxfinite1073, %4222, !dbg !1096
  %overflow_cond1078 = and i1 %4211, %is_inf1072, !dbg !1096
  br i1 %overflow_cond1078, label %4223, label %4225, !dbg !1096

4223:                                             ; preds = %4204
  %4224 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %4225, !dbg !1096

4225:                                             ; preds = %4204, %4223
  %4226 = bitcast float %4205 to i32, !dbg !1096
  %4227 = fcmp olt float %763, 0.000000e+00, !dbg !1096
  br i1 %4227, label %4228, label %4230, !dbg !1096

4228:                                             ; preds = %4225
  %4229 = xor i32 %4226, 2139095040, !dbg !1096
  br label %4230, !dbg !1096

4230:                                             ; preds = %4228, %4225
  %ti.i.0.i = phi i32 [ %4229, %4228 ], [ %4226, %4225 ], !dbg !1096
  %4231 = icmp eq i32 %952, 0, !dbg !1096
  br i1 %4231, label %4232, label %4234, !dbg !1096

4232:                                             ; preds = %4230
  %4233 = and i32 %ti.i.0.i, 2147483647, !dbg !1096
  br label %4234, !dbg !1096

4234:                                             ; preds = %4232, %4230
  %ti.i.1.i = phi i32 [ %4233, %4232 ], [ %ti.i.0.i, %4230 ], !dbg !1096
  %4235 = bitcast i32 %ti.i.1.i to float, !dbg !1096
  br label %4295, !dbg !1096

4236:                                             ; preds = %4162
  %4237 = fcmp oeq float %762, -1.000000e+00, !dbg !1096
  br i1 %4237, label %4238, label %4243, !dbg !1096

4238:                                             ; preds = %4236
  %4239 = call float @llvm.nvvm.fabs.f32(float %763), !dbg !1096
  %4240 = fcmp oeq float %4239, 0x7FF0000000000000, !dbg !1096
  %4241 = select i1 %4240, i32 1, i32 0, !dbg !1096
  br i1 %4240, label %4242, label %4243, !dbg !1096

4242:                                             ; preds = %4238
  br label %4294, !dbg !1096

4243:                                             ; preds = %4238, %4236
  %4244 = fcmp olt float %762, 0.000000e+00, !dbg !1096
  br i1 %4244, label %4245, label %4293, !dbg !1096

4245:                                             ; preds = %4243
  br i1 %951, label %4246, label %4288, !dbg !1096

4246:                                             ; preds = %4245
  %4247 = bitcast float %t.i.0.i to i32, !dbg !1096
  %4248 = bitcast float %t.i.0.i to i32, !dbg !1096
  %4249 = and i32 %4248, 2139095040, !dbg !1096
  %4250 = icmp eq i32 %4249, 2139095040, !dbg !1096
  %4251 = and i32 %4248, 8388607, !dbg !1096
  %4252 = icmp ne i32 %4251, 0, !dbg !1096
  %is_nan1079 = and i1 %4250, %4252, !dbg !1096
  %4253 = and i32 %4247, 4194304, !dbg !1096
  %4254 = icmp eq i32 %4253, 0, !dbg !1096
  %is_snan1080 = and i1 %is_nan1079, %4254, !dbg !1096
  %4255 = or i1 false, %is_snan1080, !dbg !1096
  %4256 = bitcast float %t.i.0.i to i32, !dbg !1096
  %4257 = and i32 %4256, 2139095040, !dbg !1096
  %4258 = icmp eq i32 %4257, 2139095040, !dbg !1096
  %4259 = and i32 %4256, 8388607, !dbg !1096
  %4260 = icmp eq i32 %4259, 0, !dbg !1096
  %is_inf1081 = and i1 %4258, %4260, !dbg !1096
  %4261 = and i1 false, %is_inf1081, !dbg !1096
  %4262 = bitcast float %t.i.0.i to i32, !dbg !1096
  %4263 = and i32 %4262, -2147483648, !dbg !1096
  %4264 = icmp eq i32 -2147483648, %4263, !dbg !1096
  %4265 = and i1 %4261, %4264, !dbg !1096
  %4266 = or i1 %4255, %4265, !dbg !1096
  br i1 %4266, label %4267, label %4269, !dbg !1096

4267:                                             ; preds = %4246
  %4268 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %4269, !dbg !1096

4269:                                             ; preds = %4246, %4267
  %4270 = fsub float -0.000000e+00, %t.i.0.i, !dbg !1096
  %4271 = bitcast float %t.i.0.i to i32, !dbg !1096
  %4272 = and i32 %4271, 2139095040, !dbg !1096
  %is_finite1082 = icmp ne i32 %4272, 2139095040, !dbg !1096
  %4273 = and i1 true, %is_finite1082, !dbg !1096
  %4274 = bitcast float %4270 to i32, !dbg !1096
  %4275 = and i32 %4274, 2139095040, !dbg !1096
  %4276 = icmp eq i32 %4275, 2139095040, !dbg !1096
  %4277 = and i32 %4274, 8388607, !dbg !1096
  %4278 = icmp eq i32 %4277, 0, !dbg !1096
  %is_inf1083 = and i1 %4276, %4278, !dbg !1096
  %4279 = bitcast float %4270 to i32, !dbg !1096
  %4280 = and i32 %4279, 2147483647, !dbg !1096
  %is_maxfinite1084 = icmp eq i32 %4280, 2139095039, !dbg !1096
  %4281 = bitcast float %4270 to i32, !dbg !1096
  %4282 = and i32 %4281, -2147483648, !dbg !1096
  %4283 = icmp eq i32 %4282, 0, !dbg !1096
  %4284 = icmp ne i32 %4282, 0, !dbg !1096
  %is_pos_inf1085 = and i1 %is_inf1083, %4283, !dbg !1096
  %is_neg_inf1086 = and i1 %is_inf1083, %4284, !dbg !1096
  %is_pos_max1087 = and i1 %is_maxfinite1084, %4283, !dbg !1096
  %is_neg_max1088 = and i1 %is_maxfinite1084, %4284, !dbg !1096
  %overflow_cond1089 = and i1 %4273, %is_inf1083, !dbg !1096
  br i1 %overflow_cond1089, label %4285, label %4287, !dbg !1096

4285:                                             ; preds = %4269
  %4286 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1096
  br label %4287, !dbg !1096

4287:                                             ; preds = %4269, %4285
  br label %4288, !dbg !1096

4288:                                             ; preds = %4287, %4245
  %.01.i = phi float [ %4270, %4287 ], [ %t.i.0.i, %4245 ], !dbg !1096
  %4289 = call float @llvm.nvvm.floor.f(float %763) #5, !dbg !1096
  %4290 = fcmp une float %763, %4289, !dbg !1096
  br i1 %4290, label %4291, label %4292, !dbg !1096

4291:                                             ; preds = %4288
  br label %4292, !dbg !1096

4292:                                             ; preds = %4291, %4288
  %.1.i = phi float [ 0x7FFFFFFFE0000000, %4291 ], [ %.01.i, %4288 ], !dbg !1096
  br label %4293, !dbg !1096

4293:                                             ; preds = %4292, %4243
  %.2.i = phi float [ %.1.i, %4292 ], [ %t.i.0.i, %4243 ], !dbg !1096
  br label %4294, !dbg !1096

4294:                                             ; preds = %4293, %4242
  %.3.i = phi float [ 1.000000e+00, %4242 ], [ %.2.i, %4293 ], !dbg !1096
  br label %4295, !dbg !1096

4295:                                             ; preds = %4294, %4234
  %.4.i = phi float [ %4235, %4234 ], [ %.3.i, %4294 ], !dbg !1096
  br label %4296, !dbg !1096

4296:                                             ; preds = %4295, %4159
  %.5.i = phi float [ %4139, %4159 ], [ %.4.i, %4295 ], !dbg !1096
  br label %__nv_powf.exit, !dbg !1096

__nv_powf.exit:                                   ; preds = %4089, %4296
  %.6.i = phi float [ 1.000000e+00, %4089 ], [ %.5.i, %4296 ], !dbg !1096
  %4297 = load ptr, ptr %result.addr, align 8, !dbg !1098
  %arrayidx49 = getelementptr inbounds float, ptr %4297, i64 6, !dbg !1098
  store float %.6.i, ptr %arrayidx49, align 4, !dbg !1099
  %4298 = load ptr, ptr %result.addr, align 8, !dbg !1100
  %arrayidx50 = getelementptr inbounds float, ptr %4298, i64 6, !dbg !1100
  %4299 = load float, ptr %arrayidx50, align 4, !dbg !1100
  %call51 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %4299) #4, !dbg !1101
  %4300 = zext i1 %call51 to i64, !dbg !1101
  %cond52 = select i1 %call51, i32 1, i32 0, !dbg !1101
  %4301 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1102
  %arrayidx53 = getelementptr inbounds i32, ptr %4301, i64 6, !dbg !1102
  store i32 %cond52, ptr %arrayidx53, align 4, !dbg !1103
  br label %if.end54, !dbg !1104

if.end54:                                         ; preds = %__nv_powf.exit, %if.end45
  %4302 = load i32, ptr %idx, align 4, !dbg !1105
  %cmp55 = icmp eq i32 %4302, 7, !dbg !1107
  br i1 %cmp55, label %if.then56, label %if.end63, !dbg !1107

if.then56:                                        ; preds = %if.end54
  store float 1.000000e+00, ptr %__a.addr.i68, align 4
    #dbg_declare(ptr %__a.addr.i68, !1108, !DIExpression(), !1109)
  %4303 = load float, ptr %__a.addr.i68, align 4, !dbg !1112
  %4304 = fcmp olt float %4303, 0x3810000000000000, !dbg !1113
  br i1 %4304, label %4305, label %4371, !dbg !1113

4305:                                             ; preds = %if.then56
  %4306 = bitcast float %4303 to i32, !dbg !1113
  %4307 = bitcast float %4303 to i32, !dbg !1113
  %4308 = and i32 %4307, 2139095040, !dbg !1113
  %4309 = icmp eq i32 %4308, 2139095040, !dbg !1113
  %4310 = and i32 %4307, 8388607, !dbg !1113
  %4311 = icmp ne i32 %4310, 0, !dbg !1113
  %is_nan1090 = and i1 %4309, %4311, !dbg !1113
  %4312 = and i32 %4306, 4194304, !dbg !1113
  %4313 = icmp eq i32 %4312, 0, !dbg !1113
  %is_snan1091 = and i1 %is_nan1090, %4313, !dbg !1113
  %4314 = or i1 %is_snan1091, false, !dbg !1113
  %4315 = bitcast float %4303 to i32, !dbg !1113
  %4316 = and i32 %4315, 2147483647, !dbg !1113
  %is_zero1092 = icmp eq i32 %4316, 0, !dbg !1113
  %4317 = and i1 %is_zero1092, false, !dbg !1113
  %4318 = bitcast float %4303 to i32, !dbg !1113
  %4319 = and i32 %4318, 2139095040, !dbg !1113
  %4320 = icmp eq i32 %4319, 2139095040, !dbg !1113
  %4321 = and i32 %4318, 8388607, !dbg !1113
  %4322 = icmp eq i32 %4321, 0, !dbg !1113
  %is_inf1093 = and i1 %4320, %4322, !dbg !1113
  %4323 = and i1 %is_inf1093, false, !dbg !1113
  %4324 = or i1 %4317, %4323, !dbg !1113
  %4325 = or i1 %4314, %4324, !dbg !1113
  br i1 %4325, label %4326, label %4328, !dbg !1113

4326:                                             ; preds = %4305
  %4327 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4328, !dbg !1113

4328:                                             ; preds = %4305, %4326
  %4329 = fmul float %4303, 0x4160000000000000, !dbg !1113
  %4330 = bitcast float %4303 to i32, !dbg !1113
  %4331 = and i32 %4330, 2139095040, !dbg !1113
  %is_finite1094 = icmp ne i32 %4331, 2139095040, !dbg !1113
  %4332 = and i1 true, %is_finite1094, !dbg !1113
  %4333 = and i1 %4332, true, !dbg !1113
  %4334 = bitcast float %4329 to i32, !dbg !1113
  %4335 = and i32 %4334, 2139095040, !dbg !1113
  %4336 = icmp eq i32 %4335, 2139095040, !dbg !1113
  %4337 = and i32 %4334, 8388607, !dbg !1113
  %4338 = icmp eq i32 %4337, 0, !dbg !1113
  %is_inf1095 = and i1 %4336, %4338, !dbg !1113
  %4339 = bitcast float %4329 to i32, !dbg !1113
  %4340 = and i32 %4339, 2147483647, !dbg !1113
  %is_maxfinite1096 = icmp eq i32 %4340, 2139095039, !dbg !1113
  %4341 = bitcast float %4329 to i32, !dbg !1113
  %4342 = and i32 %4341, -2147483648, !dbg !1113
  %4343 = icmp eq i32 %4342, 0, !dbg !1113
  %4344 = icmp ne i32 %4342, 0, !dbg !1113
  %is_pos_inf1097 = and i1 %is_inf1095, %4343, !dbg !1113
  %is_neg_inf1098 = and i1 %is_inf1095, %4344, !dbg !1113
  %is_pos_max1099 = and i1 %is_maxfinite1096, %4343, !dbg !1113
  %is_neg_max1100 = and i1 %is_maxfinite1096, %4344, !dbg !1113
  %overflow_cond1101 = and i1 %4333, %is_inf1095, !dbg !1113
  br i1 %overflow_cond1101, label %4345, label %4347, !dbg !1113

4345:                                             ; preds = %4328
  %4346 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4347, !dbg !1113

4347:                                             ; preds = %4328, %4345
  %4348 = bitcast float %4303 to i32, !dbg !1113
  %4349 = and i32 %4348, 2139095040, !dbg !1113
  %4350 = icmp eq i32 %4349, 0, !dbg !1113
  %4351 = and i32 %4348, 8388607, !dbg !1113
  %4352 = icmp ne i32 %4351, 0, !dbg !1113
  %is_subnormal1102 = and i1 %4350, %4352, !dbg !1113
  %4353 = xor i1 %is_subnormal1102, true, !dbg !1113
  %4354 = and i1 true, %4353, !dbg !1113
  %4355 = and i1 %4354, true, !dbg !1113
  %4356 = bitcast float %4329 to i32, !dbg !1113
  %4357 = and i32 %4356, 2139095040, !dbg !1113
  %4358 = icmp eq i32 %4357, 0, !dbg !1113
  %4359 = and i32 %4356, 8388607, !dbg !1113
  %4360 = icmp ne i32 %4359, 0, !dbg !1113
  %is_subnormal1103 = and i1 %4358, %4360, !dbg !1113
  %4361 = bitcast float %4329 to i32, !dbg !1113
  %4362 = and i32 %4361, 2147483647, !dbg !1113
  %is_zero1104 = icmp eq i32 %4362, 0, !dbg !1113
  %4363 = bitcast float %4303 to i32, !dbg !1113
  %4364 = and i32 %4363, 2147483647, !dbg !1113
  %is_zero1105 = icmp eq i32 %4364, 0, !dbg !1113
  %4365 = xor i1 %is_zero1105, true, !dbg !1113
  %4366 = and i1 %4365, true, !dbg !1113
  %4367 = and i1 %is_zero1104, %4366, !dbg !1113
  %is_tiny1106 = or i1 %is_subnormal1103, %4367, !dbg !1113
  %underflow_cond1107 = and i1 %4355, %is_tiny1106, !dbg !1113
  br i1 %underflow_cond1107, label %4368, label %4370, !dbg !1113

4368:                                             ; preds = %4347
  %4369 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4370, !dbg !1113

4370:                                             ; preds = %4347, %4368
  br label %4371, !dbg !1113

4371:                                             ; preds = %4370, %if.then56
  %.02.i = phi float [ %4329, %4370 ], [ %4303, %if.then56 ], !dbg !1113
  %i.i.0.i = phi float [ -2.300000e+01, %4370 ], [ 0.000000e+00, %if.then56 ], !dbg !1113
  %4372 = bitcast float %.02.i to i32, !dbg !1113
  %4373 = sub i32 %4372, 1059760811, !dbg !1113
  %4374 = and i32 %4373, -8388608, !dbg !1113
  %4375 = bitcast float %.02.i to i32, !dbg !1113
  %4376 = sub i32 %4375, %4374, !dbg !1113
  %4377 = bitcast i32 %4376 to float, !dbg !1113
  %4378 = sitofp i32 %4374 to float, !dbg !1113
  %4379 = bitcast float %4378 to i32, !dbg !1113
  %4380 = bitcast float %4378 to i32, !dbg !1113
  %4381 = and i32 %4380, 2139095040, !dbg !1113
  %4382 = icmp eq i32 %4381, 2139095040, !dbg !1113
  %4383 = and i32 %4380, 8388607, !dbg !1113
  %4384 = icmp ne i32 %4383, 0, !dbg !1113
  %is_nan1108 = and i1 %4382, %4384, !dbg !1113
  %4385 = and i32 %4379, 4194304, !dbg !1113
  %4386 = icmp eq i32 %4385, 0, !dbg !1113
  %is_snan1109 = and i1 %is_nan1108, %4386, !dbg !1113
  %4387 = or i1 %is_snan1109, false, !dbg !1113
  %4388 = bitcast float %i.i.0.i to i32, !dbg !1113
  %4389 = bitcast float %i.i.0.i to i32, !dbg !1113
  %4390 = and i32 %4389, 2139095040, !dbg !1113
  %4391 = icmp eq i32 %4390, 2139095040, !dbg !1113
  %4392 = and i32 %4389, 8388607, !dbg !1113
  %4393 = icmp ne i32 %4392, 0, !dbg !1113
  %is_nan1110 = and i1 %4391, %4393, !dbg !1113
  %4394 = and i32 %4388, 4194304, !dbg !1113
  %4395 = icmp eq i32 %4394, 0, !dbg !1113
  %is_snan1111 = and i1 %is_nan1110, %4395, !dbg !1113
  %4396 = or i1 %4387, %is_snan1111, !dbg !1113
  %4397 = bitcast float %4378 to i32, !dbg !1113
  %4398 = and i32 %4397, 2147483647, !dbg !1113
  %is_zero1112 = icmp eq i32 %4398, 0, !dbg !1113
  %4399 = and i1 %is_zero1112, false, !dbg !1113
  %4400 = bitcast float %4378 to i32, !dbg !1113
  %4401 = and i32 %4400, 2139095040, !dbg !1113
  %4402 = icmp eq i32 %4401, 2139095040, !dbg !1113
  %4403 = and i32 %4400, 8388607, !dbg !1113
  %4404 = icmp eq i32 %4403, 0, !dbg !1113
  %is_inf1113 = and i1 %4402, %4404, !dbg !1113
  %4405 = and i1 %is_inf1113, false, !dbg !1113
  %4406 = or i1 %4399, %4405, !dbg !1113
  %4407 = or i1 %4396, %4406, !dbg !1113
  br i1 %4407, label %4408, label %4410, !dbg !1113

4408:                                             ; preds = %4371
  %4409 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4410, !dbg !1113

4410:                                             ; preds = %4371, %4408
  %4411 = call float @llvm.nvvm.fma.rn.f(float %4378, float 0x3E80000000000000, float %i.i.0.i) #5, !dbg !1113
  %4412 = bitcast float %4378 to i32, !dbg !1113
  %4413 = and i32 %4412, 2139095040, !dbg !1113
  %is_finite1114 = icmp ne i32 %4413, 2139095040, !dbg !1113
  %4414 = and i1 true, %is_finite1114, !dbg !1113
  %4415 = and i1 %4414, true, !dbg !1113
  %4416 = bitcast float %4411 to i32, !dbg !1113
  %4417 = and i32 %4416, 2139095040, !dbg !1113
  %4418 = icmp eq i32 %4417, 2139095040, !dbg !1113
  %4419 = and i32 %4416, 8388607, !dbg !1113
  %4420 = icmp eq i32 %4419, 0, !dbg !1113
  %is_inf1115 = and i1 %4418, %4420, !dbg !1113
  %4421 = bitcast float %4411 to i32, !dbg !1113
  %4422 = and i32 %4421, 2147483647, !dbg !1113
  %is_maxfinite1116 = icmp eq i32 %4422, 2139095039, !dbg !1113
  %4423 = bitcast float %4411 to i32, !dbg !1113
  %4424 = and i32 %4423, -2147483648, !dbg !1113
  %4425 = icmp eq i32 %4424, 0, !dbg !1113
  %4426 = icmp ne i32 %4424, 0, !dbg !1113
  %is_pos_inf1117 = and i1 %is_inf1115, %4425, !dbg !1113
  %is_neg_inf1118 = and i1 %is_inf1115, %4426, !dbg !1113
  %is_pos_max1119 = and i1 %is_maxfinite1116, %4425, !dbg !1113
  %is_neg_max1120 = and i1 %is_maxfinite1116, %4426, !dbg !1113
  %overflow_cond1121 = and i1 %4415, %is_inf1115, !dbg !1113
  br i1 %overflow_cond1121, label %4427, label %4429, !dbg !1113

4427:                                             ; preds = %4410
  %4428 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4429, !dbg !1113

4429:                                             ; preds = %4410, %4427
  %4430 = bitcast float %4378 to i32, !dbg !1113
  %4431 = and i32 %4430, 2139095040, !dbg !1113
  %4432 = icmp eq i32 %4431, 0, !dbg !1113
  %4433 = and i32 %4430, 8388607, !dbg !1113
  %4434 = icmp ne i32 %4433, 0, !dbg !1113
  %is_subnormal1122 = and i1 %4432, %4434, !dbg !1113
  %4435 = xor i1 %is_subnormal1122, true, !dbg !1113
  %4436 = and i1 true, %4435, !dbg !1113
  %4437 = and i1 %4436, true, !dbg !1113
  %4438 = bitcast float %i.i.0.i to i32, !dbg !1113
  %4439 = and i32 %4438, 2139095040, !dbg !1113
  %4440 = icmp eq i32 %4439, 0, !dbg !1113
  %4441 = and i32 %4438, 8388607, !dbg !1113
  %4442 = icmp ne i32 %4441, 0, !dbg !1113
  %is_subnormal1123 = and i1 %4440, %4442, !dbg !1113
  %4443 = xor i1 %is_subnormal1123, true, !dbg !1113
  %4444 = and i1 %4437, %4443, !dbg !1113
  %4445 = bitcast float %4411 to i32, !dbg !1113
  %4446 = and i32 %4445, 2139095040, !dbg !1113
  %4447 = icmp eq i32 %4446, 0, !dbg !1113
  %4448 = and i32 %4445, 8388607, !dbg !1113
  %4449 = icmp ne i32 %4448, 0, !dbg !1113
  %is_subnormal1124 = and i1 %4447, %4449, !dbg !1113
  %is_tiny1125 = or i1 %is_subnormal1124, false, !dbg !1113
  %underflow_cond1126 = and i1 %4444, %is_tiny1125, !dbg !1113
  br i1 %underflow_cond1126, label %4450, label %4452, !dbg !1113

4450:                                             ; preds = %4429
  %4451 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4452, !dbg !1113

4452:                                             ; preds = %4429, %4450
  %4453 = bitcast float %4377 to i32, !dbg !1113
  %4454 = bitcast float %4377 to i32, !dbg !1113
  %4455 = and i32 %4454, 2139095040, !dbg !1113
  %4456 = icmp eq i32 %4455, 2139095040, !dbg !1113
  %4457 = and i32 %4454, 8388607, !dbg !1113
  %4458 = icmp ne i32 %4457, 0, !dbg !1113
  %is_nan1127 = and i1 %4456, %4458, !dbg !1113
  %4459 = and i32 %4453, 4194304, !dbg !1113
  %4460 = icmp eq i32 %4459, 0, !dbg !1113
  %is_snan1128 = and i1 %is_nan1127, %4460, !dbg !1113
  %4461 = or i1 %is_snan1128, false, !dbg !1113
  %4462 = bitcast float %4377 to i32, !dbg !1113
  %4463 = and i32 %4462, 2139095040, !dbg !1113
  %4464 = icmp eq i32 %4463, 2139095040, !dbg !1113
  %4465 = and i32 %4462, 8388607, !dbg !1113
  %4466 = icmp eq i32 %4465, 0, !dbg !1113
  %is_inf1129 = and i1 %4464, %4466, !dbg !1113
  %4467 = and i1 %is_inf1129, false, !dbg !1113
  %4468 = bitcast float %4377 to i32, !dbg !1113
  %4469 = and i32 %4468, -2147483648, !dbg !1113
  %4470 = icmp eq i32 %4469, 0, !dbg !1113
  %4471 = and i1 %4467, %4470, !dbg !1113
  %4472 = or i1 %4461, %4471, !dbg !1113
  br i1 %4472, label %4473, label %4475, !dbg !1113

4473:                                             ; preds = %4452
  %4474 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4475, !dbg !1113

4475:                                             ; preds = %4452, %4473
  %4476 = fsub float %4377, 1.000000e+00, !dbg !1113
  %4477 = bitcast float %4377 to i32, !dbg !1113
  %4478 = and i32 %4477, 2139095040, !dbg !1113
  %is_finite1130 = icmp ne i32 %4478, 2139095040, !dbg !1113
  %4479 = and i1 true, %is_finite1130, !dbg !1113
  %4480 = and i1 %4479, true, !dbg !1113
  %4481 = bitcast float %4476 to i32, !dbg !1113
  %4482 = and i32 %4481, 2139095040, !dbg !1113
  %4483 = icmp eq i32 %4482, 2139095040, !dbg !1113
  %4484 = and i32 %4481, 8388607, !dbg !1113
  %4485 = icmp eq i32 %4484, 0, !dbg !1113
  %is_inf1131 = and i1 %4483, %4485, !dbg !1113
  %4486 = bitcast float %4476 to i32, !dbg !1113
  %4487 = and i32 %4486, 2147483647, !dbg !1113
  %is_maxfinite1132 = icmp eq i32 %4487, 2139095039, !dbg !1113
  %4488 = bitcast float %4476 to i32, !dbg !1113
  %4489 = and i32 %4488, -2147483648, !dbg !1113
  %4490 = icmp eq i32 %4489, 0, !dbg !1113
  %4491 = icmp ne i32 %4489, 0, !dbg !1113
  %is_pos_inf1133 = and i1 %is_inf1131, %4490, !dbg !1113
  %is_neg_inf1134 = and i1 %is_inf1131, %4491, !dbg !1113
  %is_pos_max1135 = and i1 %is_maxfinite1132, %4490, !dbg !1113
  %is_neg_max1136 = and i1 %is_maxfinite1132, %4491, !dbg !1113
  %overflow_cond1137 = and i1 %4480, %is_inf1131, !dbg !1113
  br i1 %overflow_cond1137, label %4492, label %4494, !dbg !1113

4492:                                             ; preds = %4475
  %4493 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4494, !dbg !1113

4494:                                             ; preds = %4475, %4492
  %4495 = bitcast float %4476 to i32, !dbg !1113
  %4496 = bitcast float %4476 to i32, !dbg !1113
  %4497 = and i32 %4496, 2139095040, !dbg !1113
  %4498 = icmp eq i32 %4497, 2139095040, !dbg !1113
  %4499 = and i32 %4496, 8388607, !dbg !1113
  %4500 = icmp ne i32 %4499, 0, !dbg !1113
  %is_nan1138 = and i1 %4498, %4500, !dbg !1113
  %4501 = and i32 %4495, 4194304, !dbg !1113
  %4502 = icmp eq i32 %4501, 0, !dbg !1113
  %is_snan1139 = and i1 %is_nan1138, %4502, !dbg !1113
  %4503 = or i1 false, %is_snan1139, !dbg !1113
  %4504 = or i1 %4503, false, !dbg !1113
  %4505 = bitcast float %4476 to i32, !dbg !1113
  %4506 = and i32 %4505, 2139095040, !dbg !1113
  %4507 = icmp eq i32 %4506, 2139095040, !dbg !1113
  %4508 = and i32 %4505, 8388607, !dbg !1113
  %4509 = icmp eq i32 %4508, 0, !dbg !1113
  %is_inf1140 = and i1 %4507, %4509, !dbg !1113
  %4510 = and i1 false, %is_inf1140, !dbg !1113
  %4511 = bitcast float %4476 to i32, !dbg !1113
  %4512 = and i32 %4511, 2147483647, !dbg !1113
  %is_zero1141 = icmp eq i32 %4512, 0, !dbg !1113
  %4513 = and i1 false, %is_zero1141, !dbg !1113
  %4514 = or i1 %4510, %4513, !dbg !1113
  %4515 = or i1 %4504, %4514, !dbg !1113
  br i1 %4515, label %4516, label %4518, !dbg !1113

4516:                                             ; preds = %4494
  %4517 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4518, !dbg !1113

4518:                                             ; preds = %4494, %4516
  %4519 = call float @llvm.nvvm.fma.rn.f(float 0xBFC0AA04E0000000, float %4476, float 0x3FC2073EC0000000) #5, !dbg !1113
  %4520 = bitcast float %4476 to i32, !dbg !1113
  %4521 = and i32 %4520, 2139095040, !dbg !1113
  %is_finite1142 = icmp ne i32 %4521, 2139095040, !dbg !1113
  %4522 = and i1 true, %is_finite1142, !dbg !1113
  %4523 = bitcast float %4519 to i32, !dbg !1113
  %4524 = and i32 %4523, 2139095040, !dbg !1113
  %4525 = icmp eq i32 %4524, 2139095040, !dbg !1113
  %4526 = and i32 %4523, 8388607, !dbg !1113
  %4527 = icmp eq i32 %4526, 0, !dbg !1113
  %is_inf1143 = and i1 %4525, %4527, !dbg !1113
  %4528 = bitcast float %4519 to i32, !dbg !1113
  %4529 = and i32 %4528, 2147483647, !dbg !1113
  %is_maxfinite1144 = icmp eq i32 %4529, 2139095039, !dbg !1113
  %4530 = bitcast float %4519 to i32, !dbg !1113
  %4531 = and i32 %4530, -2147483648, !dbg !1113
  %4532 = icmp eq i32 %4531, 0, !dbg !1113
  %4533 = icmp ne i32 %4531, 0, !dbg !1113
  %is_pos_inf1145 = and i1 %is_inf1143, %4532, !dbg !1113
  %is_neg_inf1146 = and i1 %is_inf1143, %4533, !dbg !1113
  %is_pos_max1147 = and i1 %is_maxfinite1144, %4532, !dbg !1113
  %is_neg_max1148 = and i1 %is_maxfinite1144, %4533, !dbg !1113
  %overflow_cond1149 = and i1 %4522, %is_inf1143, !dbg !1113
  br i1 %overflow_cond1149, label %4534, label %4536, !dbg !1113

4534:                                             ; preds = %4518
  %4535 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4536, !dbg !1113

4536:                                             ; preds = %4518, %4534
  %4537 = bitcast float %4476 to i32, !dbg !1113
  %4538 = and i32 %4537, 2139095040, !dbg !1113
  %4539 = icmp eq i32 %4538, 0, !dbg !1113
  %4540 = and i32 %4537, 8388607, !dbg !1113
  %4541 = icmp ne i32 %4540, 0, !dbg !1113
  %is_subnormal1150 = and i1 %4539, %4541, !dbg !1113
  %4542 = xor i1 %is_subnormal1150, true, !dbg !1113
  %4543 = and i1 true, %4542, !dbg !1113
  %4544 = and i1 %4543, true, !dbg !1113
  %4545 = bitcast float %4519 to i32, !dbg !1113
  %4546 = and i32 %4545, 2139095040, !dbg !1113
  %4547 = icmp eq i32 %4546, 0, !dbg !1113
  %4548 = and i32 %4545, 8388607, !dbg !1113
  %4549 = icmp ne i32 %4548, 0, !dbg !1113
  %is_subnormal1151 = and i1 %4547, %4549, !dbg !1113
  %is_tiny1152 = or i1 %is_subnormal1151, false, !dbg !1113
  %underflow_cond1153 = and i1 %4544, %is_tiny1152, !dbg !1113
  br i1 %underflow_cond1153, label %4550, label %4552, !dbg !1113

4550:                                             ; preds = %4536
  %4551 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4552, !dbg !1113

4552:                                             ; preds = %4536, %4550
  %4553 = bitcast float %4519 to i32, !dbg !1113
  %4554 = bitcast float %4519 to i32, !dbg !1113
  %4555 = and i32 %4554, 2139095040, !dbg !1113
  %4556 = icmp eq i32 %4555, 2139095040, !dbg !1113
  %4557 = and i32 %4554, 8388607, !dbg !1113
  %4558 = icmp ne i32 %4557, 0, !dbg !1113
  %is_nan1154 = and i1 %4556, %4558, !dbg !1113
  %4559 = and i32 %4553, 4194304, !dbg !1113
  %4560 = icmp eq i32 %4559, 0, !dbg !1113
  %is_snan1155 = and i1 %is_nan1154, %4560, !dbg !1113
  %4561 = bitcast float %4476 to i32, !dbg !1113
  %4562 = bitcast float %4476 to i32, !dbg !1113
  %4563 = and i32 %4562, 2139095040, !dbg !1113
  %4564 = icmp eq i32 %4563, 2139095040, !dbg !1113
  %4565 = and i32 %4562, 8388607, !dbg !1113
  %4566 = icmp ne i32 %4565, 0, !dbg !1113
  %is_nan1156 = and i1 %4564, %4566, !dbg !1113
  %4567 = and i32 %4561, 4194304, !dbg !1113
  %4568 = icmp eq i32 %4567, 0, !dbg !1113
  %is_snan1157 = and i1 %is_nan1156, %4568, !dbg !1113
  %4569 = or i1 %is_snan1155, %is_snan1157, !dbg !1113
  %4570 = or i1 %4569, false, !dbg !1113
  %4571 = bitcast float %4519 to i32, !dbg !1113
  %4572 = and i32 %4571, 2147483647, !dbg !1113
  %is_zero1158 = icmp eq i32 %4572, 0, !dbg !1113
  %4573 = bitcast float %4476 to i32, !dbg !1113
  %4574 = and i32 %4573, 2139095040, !dbg !1113
  %4575 = icmp eq i32 %4574, 2139095040, !dbg !1113
  %4576 = and i32 %4573, 8388607, !dbg !1113
  %4577 = icmp eq i32 %4576, 0, !dbg !1113
  %is_inf1159 = and i1 %4575, %4577, !dbg !1113
  %4578 = and i1 %is_zero1158, %is_inf1159, !dbg !1113
  %4579 = bitcast float %4519 to i32, !dbg !1113
  %4580 = and i32 %4579, 2139095040, !dbg !1113
  %4581 = icmp eq i32 %4580, 2139095040, !dbg !1113
  %4582 = and i32 %4579, 8388607, !dbg !1113
  %4583 = icmp eq i32 %4582, 0, !dbg !1113
  %is_inf1160 = and i1 %4581, %4583, !dbg !1113
  %4584 = bitcast float %4476 to i32, !dbg !1113
  %4585 = and i32 %4584, 2147483647, !dbg !1113
  %is_zero1161 = icmp eq i32 %4585, 0, !dbg !1113
  %4586 = and i1 %is_inf1160, %is_zero1161, !dbg !1113
  %4587 = or i1 %4578, %4586, !dbg !1113
  %4588 = or i1 %4570, %4587, !dbg !1113
  br i1 %4588, label %4589, label %4591, !dbg !1113

4589:                                             ; preds = %4552
  %4590 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4591, !dbg !1113

4591:                                             ; preds = %4552, %4589
  %4592 = call float @llvm.nvvm.fma.rn.f(float %4519, float %4476, float 0xBFBF19B980000000) #5, !dbg !1113
  %4593 = bitcast float %4519 to i32, !dbg !1113
  %4594 = and i32 %4593, 2139095040, !dbg !1113
  %is_finite1162 = icmp ne i32 %4594, 2139095040, !dbg !1113
  %4595 = and i1 true, %is_finite1162, !dbg !1113
  %4596 = bitcast float %4476 to i32, !dbg !1113
  %4597 = and i32 %4596, 2139095040, !dbg !1113
  %is_finite1163 = icmp ne i32 %4597, 2139095040, !dbg !1113
  %4598 = and i1 %4595, %is_finite1163, !dbg !1113
  %4599 = bitcast float %4592 to i32, !dbg !1113
  %4600 = and i32 %4599, 2139095040, !dbg !1113
  %4601 = icmp eq i32 %4600, 2139095040, !dbg !1113
  %4602 = and i32 %4599, 8388607, !dbg !1113
  %4603 = icmp eq i32 %4602, 0, !dbg !1113
  %is_inf1164 = and i1 %4601, %4603, !dbg !1113
  %4604 = bitcast float %4592 to i32, !dbg !1113
  %4605 = and i32 %4604, 2147483647, !dbg !1113
  %is_maxfinite1165 = icmp eq i32 %4605, 2139095039, !dbg !1113
  %4606 = bitcast float %4592 to i32, !dbg !1113
  %4607 = and i32 %4606, -2147483648, !dbg !1113
  %4608 = icmp eq i32 %4607, 0, !dbg !1113
  %4609 = icmp ne i32 %4607, 0, !dbg !1113
  %is_pos_inf1166 = and i1 %is_inf1164, %4608, !dbg !1113
  %is_neg_inf1167 = and i1 %is_inf1164, %4609, !dbg !1113
  %is_pos_max1168 = and i1 %is_maxfinite1165, %4608, !dbg !1113
  %is_neg_max1169 = and i1 %is_maxfinite1165, %4609, !dbg !1113
  %overflow_cond1170 = and i1 %4598, %is_inf1164, !dbg !1113
  br i1 %overflow_cond1170, label %4610, label %4612, !dbg !1113

4610:                                             ; preds = %4591
  %4611 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4612, !dbg !1113

4612:                                             ; preds = %4591, %4610
  %4613 = bitcast float %4519 to i32, !dbg !1113
  %4614 = and i32 %4613, 2139095040, !dbg !1113
  %4615 = icmp eq i32 %4614, 0, !dbg !1113
  %4616 = and i32 %4613, 8388607, !dbg !1113
  %4617 = icmp ne i32 %4616, 0, !dbg !1113
  %is_subnormal1171 = and i1 %4615, %4617, !dbg !1113
  %4618 = xor i1 %is_subnormal1171, true, !dbg !1113
  %4619 = and i1 true, %4618, !dbg !1113
  %4620 = bitcast float %4476 to i32, !dbg !1113
  %4621 = and i32 %4620, 2139095040, !dbg !1113
  %4622 = icmp eq i32 %4621, 0, !dbg !1113
  %4623 = and i32 %4620, 8388607, !dbg !1113
  %4624 = icmp ne i32 %4623, 0, !dbg !1113
  %is_subnormal1172 = and i1 %4622, %4624, !dbg !1113
  %4625 = xor i1 %is_subnormal1172, true, !dbg !1113
  %4626 = and i1 %4619, %4625, !dbg !1113
  %4627 = and i1 %4626, true, !dbg !1113
  %4628 = bitcast float %4592 to i32, !dbg !1113
  %4629 = and i32 %4628, 2139095040, !dbg !1113
  %4630 = icmp eq i32 %4629, 0, !dbg !1113
  %4631 = and i32 %4628, 8388607, !dbg !1113
  %4632 = icmp ne i32 %4631, 0, !dbg !1113
  %is_subnormal1173 = and i1 %4630, %4632, !dbg !1113
  %is_tiny1174 = or i1 %is_subnormal1173, false, !dbg !1113
  %underflow_cond1175 = and i1 %4627, %is_tiny1174, !dbg !1113
  br i1 %underflow_cond1175, label %4633, label %4635, !dbg !1113

4633:                                             ; preds = %4612
  %4634 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4635, !dbg !1113

4635:                                             ; preds = %4612, %4633
  %4636 = bitcast float %4592 to i32, !dbg !1113
  %4637 = bitcast float %4592 to i32, !dbg !1113
  %4638 = and i32 %4637, 2139095040, !dbg !1113
  %4639 = icmp eq i32 %4638, 2139095040, !dbg !1113
  %4640 = and i32 %4637, 8388607, !dbg !1113
  %4641 = icmp ne i32 %4640, 0, !dbg !1113
  %is_nan1176 = and i1 %4639, %4641, !dbg !1113
  %4642 = and i32 %4636, 4194304, !dbg !1113
  %4643 = icmp eq i32 %4642, 0, !dbg !1113
  %is_snan1177 = and i1 %is_nan1176, %4643, !dbg !1113
  %4644 = bitcast float %4476 to i32, !dbg !1113
  %4645 = bitcast float %4476 to i32, !dbg !1113
  %4646 = and i32 %4645, 2139095040, !dbg !1113
  %4647 = icmp eq i32 %4646, 2139095040, !dbg !1113
  %4648 = and i32 %4645, 8388607, !dbg !1113
  %4649 = icmp ne i32 %4648, 0, !dbg !1113
  %is_nan1178 = and i1 %4647, %4649, !dbg !1113
  %4650 = and i32 %4644, 4194304, !dbg !1113
  %4651 = icmp eq i32 %4650, 0, !dbg !1113
  %is_snan1179 = and i1 %is_nan1178, %4651, !dbg !1113
  %4652 = or i1 %is_snan1177, %is_snan1179, !dbg !1113
  %4653 = or i1 %4652, false, !dbg !1113
  %4654 = bitcast float %4592 to i32, !dbg !1113
  %4655 = and i32 %4654, 2147483647, !dbg !1113
  %is_zero1180 = icmp eq i32 %4655, 0, !dbg !1113
  %4656 = bitcast float %4476 to i32, !dbg !1113
  %4657 = and i32 %4656, 2139095040, !dbg !1113
  %4658 = icmp eq i32 %4657, 2139095040, !dbg !1113
  %4659 = and i32 %4656, 8388607, !dbg !1113
  %4660 = icmp eq i32 %4659, 0, !dbg !1113
  %is_inf1181 = and i1 %4658, %4660, !dbg !1113
  %4661 = and i1 %is_zero1180, %is_inf1181, !dbg !1113
  %4662 = bitcast float %4592 to i32, !dbg !1113
  %4663 = and i32 %4662, 2139095040, !dbg !1113
  %4664 = icmp eq i32 %4663, 2139095040, !dbg !1113
  %4665 = and i32 %4662, 8388607, !dbg !1113
  %4666 = icmp eq i32 %4665, 0, !dbg !1113
  %is_inf1182 = and i1 %4664, %4666, !dbg !1113
  %4667 = bitcast float %4476 to i32, !dbg !1113
  %4668 = and i32 %4667, 2147483647, !dbg !1113
  %is_zero1183 = icmp eq i32 %4668, 0, !dbg !1113
  %4669 = and i1 %is_inf1182, %is_zero1183, !dbg !1113
  %4670 = or i1 %4661, %4669, !dbg !1113
  %4671 = or i1 %4653, %4670, !dbg !1113
  br i1 %4671, label %4672, label %4674, !dbg !1113

4672:                                             ; preds = %4635
  %4673 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4674, !dbg !1113

4674:                                             ; preds = %4635, %4672
  %4675 = call float @llvm.nvvm.fma.rn.f(float %4592, float %4476, float 0x3FC1E52AA0000000) #5, !dbg !1113
  %4676 = bitcast float %4592 to i32, !dbg !1113
  %4677 = and i32 %4676, 2139095040, !dbg !1113
  %is_finite1184 = icmp ne i32 %4677, 2139095040, !dbg !1113
  %4678 = and i1 true, %is_finite1184, !dbg !1113
  %4679 = bitcast float %4476 to i32, !dbg !1113
  %4680 = and i32 %4679, 2139095040, !dbg !1113
  %is_finite1185 = icmp ne i32 %4680, 2139095040, !dbg !1113
  %4681 = and i1 %4678, %is_finite1185, !dbg !1113
  %4682 = bitcast float %4675 to i32, !dbg !1113
  %4683 = and i32 %4682, 2139095040, !dbg !1113
  %4684 = icmp eq i32 %4683, 2139095040, !dbg !1113
  %4685 = and i32 %4682, 8388607, !dbg !1113
  %4686 = icmp eq i32 %4685, 0, !dbg !1113
  %is_inf1186 = and i1 %4684, %4686, !dbg !1113
  %4687 = bitcast float %4675 to i32, !dbg !1113
  %4688 = and i32 %4687, 2147483647, !dbg !1113
  %is_maxfinite1187 = icmp eq i32 %4688, 2139095039, !dbg !1113
  %4689 = bitcast float %4675 to i32, !dbg !1113
  %4690 = and i32 %4689, -2147483648, !dbg !1113
  %4691 = icmp eq i32 %4690, 0, !dbg !1113
  %4692 = icmp ne i32 %4690, 0, !dbg !1113
  %is_pos_inf1188 = and i1 %is_inf1186, %4691, !dbg !1113
  %is_neg_inf1189 = and i1 %is_inf1186, %4692, !dbg !1113
  %is_pos_max1190 = and i1 %is_maxfinite1187, %4691, !dbg !1113
  %is_neg_max1191 = and i1 %is_maxfinite1187, %4692, !dbg !1113
  %overflow_cond1192 = and i1 %4681, %is_inf1186, !dbg !1113
  br i1 %overflow_cond1192, label %4693, label %4695, !dbg !1113

4693:                                             ; preds = %4674
  %4694 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4695, !dbg !1113

4695:                                             ; preds = %4674, %4693
  %4696 = bitcast float %4592 to i32, !dbg !1113
  %4697 = and i32 %4696, 2139095040, !dbg !1113
  %4698 = icmp eq i32 %4697, 0, !dbg !1113
  %4699 = and i32 %4696, 8388607, !dbg !1113
  %4700 = icmp ne i32 %4699, 0, !dbg !1113
  %is_subnormal1193 = and i1 %4698, %4700, !dbg !1113
  %4701 = xor i1 %is_subnormal1193, true, !dbg !1113
  %4702 = and i1 true, %4701, !dbg !1113
  %4703 = bitcast float %4476 to i32, !dbg !1113
  %4704 = and i32 %4703, 2139095040, !dbg !1113
  %4705 = icmp eq i32 %4704, 0, !dbg !1113
  %4706 = and i32 %4703, 8388607, !dbg !1113
  %4707 = icmp ne i32 %4706, 0, !dbg !1113
  %is_subnormal1194 = and i1 %4705, %4707, !dbg !1113
  %4708 = xor i1 %is_subnormal1194, true, !dbg !1113
  %4709 = and i1 %4702, %4708, !dbg !1113
  %4710 = and i1 %4709, true, !dbg !1113
  %4711 = bitcast float %4675 to i32, !dbg !1113
  %4712 = and i32 %4711, 2139095040, !dbg !1113
  %4713 = icmp eq i32 %4712, 0, !dbg !1113
  %4714 = and i32 %4711, 8388607, !dbg !1113
  %4715 = icmp ne i32 %4714, 0, !dbg !1113
  %is_subnormal1195 = and i1 %4713, %4715, !dbg !1113
  %is_tiny1196 = or i1 %is_subnormal1195, false, !dbg !1113
  %underflow_cond1197 = and i1 %4710, %is_tiny1196, !dbg !1113
  br i1 %underflow_cond1197, label %4716, label %4718, !dbg !1113

4716:                                             ; preds = %4695
  %4717 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4718, !dbg !1113

4718:                                             ; preds = %4695, %4716
  %4719 = bitcast float %4675 to i32, !dbg !1113
  %4720 = bitcast float %4675 to i32, !dbg !1113
  %4721 = and i32 %4720, 2139095040, !dbg !1113
  %4722 = icmp eq i32 %4721, 2139095040, !dbg !1113
  %4723 = and i32 %4720, 8388607, !dbg !1113
  %4724 = icmp ne i32 %4723, 0, !dbg !1113
  %is_nan1198 = and i1 %4722, %4724, !dbg !1113
  %4725 = and i32 %4719, 4194304, !dbg !1113
  %4726 = icmp eq i32 %4725, 0, !dbg !1113
  %is_snan1199 = and i1 %is_nan1198, %4726, !dbg !1113
  %4727 = bitcast float %4476 to i32, !dbg !1113
  %4728 = bitcast float %4476 to i32, !dbg !1113
  %4729 = and i32 %4728, 2139095040, !dbg !1113
  %4730 = icmp eq i32 %4729, 2139095040, !dbg !1113
  %4731 = and i32 %4728, 8388607, !dbg !1113
  %4732 = icmp ne i32 %4731, 0, !dbg !1113
  %is_nan1200 = and i1 %4730, %4732, !dbg !1113
  %4733 = and i32 %4727, 4194304, !dbg !1113
  %4734 = icmp eq i32 %4733, 0, !dbg !1113
  %is_snan1201 = and i1 %is_nan1200, %4734, !dbg !1113
  %4735 = or i1 %is_snan1199, %is_snan1201, !dbg !1113
  %4736 = or i1 %4735, false, !dbg !1113
  %4737 = bitcast float %4675 to i32, !dbg !1113
  %4738 = and i32 %4737, 2147483647, !dbg !1113
  %is_zero1202 = icmp eq i32 %4738, 0, !dbg !1113
  %4739 = bitcast float %4476 to i32, !dbg !1113
  %4740 = and i32 %4739, 2139095040, !dbg !1113
  %4741 = icmp eq i32 %4740, 2139095040, !dbg !1113
  %4742 = and i32 %4739, 8388607, !dbg !1113
  %4743 = icmp eq i32 %4742, 0, !dbg !1113
  %is_inf1203 = and i1 %4741, %4743, !dbg !1113
  %4744 = and i1 %is_zero1202, %is_inf1203, !dbg !1113
  %4745 = bitcast float %4675 to i32, !dbg !1113
  %4746 = and i32 %4745, 2139095040, !dbg !1113
  %4747 = icmp eq i32 %4746, 2139095040, !dbg !1113
  %4748 = and i32 %4745, 8388607, !dbg !1113
  %4749 = icmp eq i32 %4748, 0, !dbg !1113
  %is_inf1204 = and i1 %4747, %4749, !dbg !1113
  %4750 = bitcast float %4476 to i32, !dbg !1113
  %4751 = and i32 %4750, 2147483647, !dbg !1113
  %is_zero1205 = icmp eq i32 %4751, 0, !dbg !1113
  %4752 = and i1 %is_inf1204, %is_zero1205, !dbg !1113
  %4753 = or i1 %4744, %4752, !dbg !1113
  %4754 = or i1 %4736, %4753, !dbg !1113
  br i1 %4754, label %4755, label %4757, !dbg !1113

4755:                                             ; preds = %4718
  %4756 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4757, !dbg !1113

4757:                                             ; preds = %4718, %4755
  %4758 = call float @llvm.nvvm.fma.rn.f(float %4675, float %4476, float 0xBFC55B1720000000) #5, !dbg !1113
  %4759 = bitcast float %4675 to i32, !dbg !1113
  %4760 = and i32 %4759, 2139095040, !dbg !1113
  %is_finite1206 = icmp ne i32 %4760, 2139095040, !dbg !1113
  %4761 = and i1 true, %is_finite1206, !dbg !1113
  %4762 = bitcast float %4476 to i32, !dbg !1113
  %4763 = and i32 %4762, 2139095040, !dbg !1113
  %is_finite1207 = icmp ne i32 %4763, 2139095040, !dbg !1113
  %4764 = and i1 %4761, %is_finite1207, !dbg !1113
  %4765 = bitcast float %4758 to i32, !dbg !1113
  %4766 = and i32 %4765, 2139095040, !dbg !1113
  %4767 = icmp eq i32 %4766, 2139095040, !dbg !1113
  %4768 = and i32 %4765, 8388607, !dbg !1113
  %4769 = icmp eq i32 %4768, 0, !dbg !1113
  %is_inf1208 = and i1 %4767, %4769, !dbg !1113
  %4770 = bitcast float %4758 to i32, !dbg !1113
  %4771 = and i32 %4770, 2147483647, !dbg !1113
  %is_maxfinite1209 = icmp eq i32 %4771, 2139095039, !dbg !1113
  %4772 = bitcast float %4758 to i32, !dbg !1113
  %4773 = and i32 %4772, -2147483648, !dbg !1113
  %4774 = icmp eq i32 %4773, 0, !dbg !1113
  %4775 = icmp ne i32 %4773, 0, !dbg !1113
  %is_pos_inf1210 = and i1 %is_inf1208, %4774, !dbg !1113
  %is_neg_inf1211 = and i1 %is_inf1208, %4775, !dbg !1113
  %is_pos_max1212 = and i1 %is_maxfinite1209, %4774, !dbg !1113
  %is_neg_max1213 = and i1 %is_maxfinite1209, %4775, !dbg !1113
  %overflow_cond1214 = and i1 %4764, %is_inf1208, !dbg !1113
  br i1 %overflow_cond1214, label %4776, label %4778, !dbg !1113

4776:                                             ; preds = %4757
  %4777 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4778, !dbg !1113

4778:                                             ; preds = %4757, %4776
  %4779 = bitcast float %4675 to i32, !dbg !1113
  %4780 = and i32 %4779, 2139095040, !dbg !1113
  %4781 = icmp eq i32 %4780, 0, !dbg !1113
  %4782 = and i32 %4779, 8388607, !dbg !1113
  %4783 = icmp ne i32 %4782, 0, !dbg !1113
  %is_subnormal1215 = and i1 %4781, %4783, !dbg !1113
  %4784 = xor i1 %is_subnormal1215, true, !dbg !1113
  %4785 = and i1 true, %4784, !dbg !1113
  %4786 = bitcast float %4476 to i32, !dbg !1113
  %4787 = and i32 %4786, 2139095040, !dbg !1113
  %4788 = icmp eq i32 %4787, 0, !dbg !1113
  %4789 = and i32 %4786, 8388607, !dbg !1113
  %4790 = icmp ne i32 %4789, 0, !dbg !1113
  %is_subnormal1216 = and i1 %4788, %4790, !dbg !1113
  %4791 = xor i1 %is_subnormal1216, true, !dbg !1113
  %4792 = and i1 %4785, %4791, !dbg !1113
  %4793 = and i1 %4792, true, !dbg !1113
  %4794 = bitcast float %4758 to i32, !dbg !1113
  %4795 = and i32 %4794, 2139095040, !dbg !1113
  %4796 = icmp eq i32 %4795, 0, !dbg !1113
  %4797 = and i32 %4794, 8388607, !dbg !1113
  %4798 = icmp ne i32 %4797, 0, !dbg !1113
  %is_subnormal1217 = and i1 %4796, %4798, !dbg !1113
  %is_tiny1218 = or i1 %is_subnormal1217, false, !dbg !1113
  %underflow_cond1219 = and i1 %4793, %is_tiny1218, !dbg !1113
  br i1 %underflow_cond1219, label %4799, label %4801, !dbg !1113

4799:                                             ; preds = %4778
  %4800 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4801, !dbg !1113

4801:                                             ; preds = %4778, %4799
  %4802 = bitcast float %4758 to i32, !dbg !1113
  %4803 = bitcast float %4758 to i32, !dbg !1113
  %4804 = and i32 %4803, 2139095040, !dbg !1113
  %4805 = icmp eq i32 %4804, 2139095040, !dbg !1113
  %4806 = and i32 %4803, 8388607, !dbg !1113
  %4807 = icmp ne i32 %4806, 0, !dbg !1113
  %is_nan1220 = and i1 %4805, %4807, !dbg !1113
  %4808 = and i32 %4802, 4194304, !dbg !1113
  %4809 = icmp eq i32 %4808, 0, !dbg !1113
  %is_snan1221 = and i1 %is_nan1220, %4809, !dbg !1113
  %4810 = bitcast float %4476 to i32, !dbg !1113
  %4811 = bitcast float %4476 to i32, !dbg !1113
  %4812 = and i32 %4811, 2139095040, !dbg !1113
  %4813 = icmp eq i32 %4812, 2139095040, !dbg !1113
  %4814 = and i32 %4811, 8388607, !dbg !1113
  %4815 = icmp ne i32 %4814, 0, !dbg !1113
  %is_nan1222 = and i1 %4813, %4815, !dbg !1113
  %4816 = and i32 %4810, 4194304, !dbg !1113
  %4817 = icmp eq i32 %4816, 0, !dbg !1113
  %is_snan1223 = and i1 %is_nan1222, %4817, !dbg !1113
  %4818 = or i1 %is_snan1221, %is_snan1223, !dbg !1113
  %4819 = or i1 %4818, false, !dbg !1113
  %4820 = bitcast float %4758 to i32, !dbg !1113
  %4821 = and i32 %4820, 2147483647, !dbg !1113
  %is_zero1224 = icmp eq i32 %4821, 0, !dbg !1113
  %4822 = bitcast float %4476 to i32, !dbg !1113
  %4823 = and i32 %4822, 2139095040, !dbg !1113
  %4824 = icmp eq i32 %4823, 2139095040, !dbg !1113
  %4825 = and i32 %4822, 8388607, !dbg !1113
  %4826 = icmp eq i32 %4825, 0, !dbg !1113
  %is_inf1225 = and i1 %4824, %4826, !dbg !1113
  %4827 = and i1 %is_zero1224, %is_inf1225, !dbg !1113
  %4828 = bitcast float %4758 to i32, !dbg !1113
  %4829 = and i32 %4828, 2139095040, !dbg !1113
  %4830 = icmp eq i32 %4829, 2139095040, !dbg !1113
  %4831 = and i32 %4828, 8388607, !dbg !1113
  %4832 = icmp eq i32 %4831, 0, !dbg !1113
  %is_inf1226 = and i1 %4830, %4832, !dbg !1113
  %4833 = bitcast float %4476 to i32, !dbg !1113
  %4834 = and i32 %4833, 2147483647, !dbg !1113
  %is_zero1227 = icmp eq i32 %4834, 0, !dbg !1113
  %4835 = and i1 %is_inf1226, %is_zero1227, !dbg !1113
  %4836 = or i1 %4827, %4835, !dbg !1113
  %4837 = or i1 %4819, %4836, !dbg !1113
  br i1 %4837, label %4838, label %4840, !dbg !1113

4838:                                             ; preds = %4801
  %4839 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4840, !dbg !1113

4840:                                             ; preds = %4801, %4838
  %4841 = call float @llvm.nvvm.fma.rn.f(float %4758, float %4476, float 0x3FC99DA160000000) #5, !dbg !1113
  %4842 = bitcast float %4758 to i32, !dbg !1113
  %4843 = and i32 %4842, 2139095040, !dbg !1113
  %is_finite1228 = icmp ne i32 %4843, 2139095040, !dbg !1113
  %4844 = and i1 true, %is_finite1228, !dbg !1113
  %4845 = bitcast float %4476 to i32, !dbg !1113
  %4846 = and i32 %4845, 2139095040, !dbg !1113
  %is_finite1229 = icmp ne i32 %4846, 2139095040, !dbg !1113
  %4847 = and i1 %4844, %is_finite1229, !dbg !1113
  %4848 = bitcast float %4841 to i32, !dbg !1113
  %4849 = and i32 %4848, 2139095040, !dbg !1113
  %4850 = icmp eq i32 %4849, 2139095040, !dbg !1113
  %4851 = and i32 %4848, 8388607, !dbg !1113
  %4852 = icmp eq i32 %4851, 0, !dbg !1113
  %is_inf1230 = and i1 %4850, %4852, !dbg !1113
  %4853 = bitcast float %4841 to i32, !dbg !1113
  %4854 = and i32 %4853, 2147483647, !dbg !1113
  %is_maxfinite1231 = icmp eq i32 %4854, 2139095039, !dbg !1113
  %4855 = bitcast float %4841 to i32, !dbg !1113
  %4856 = and i32 %4855, -2147483648, !dbg !1113
  %4857 = icmp eq i32 %4856, 0, !dbg !1113
  %4858 = icmp ne i32 %4856, 0, !dbg !1113
  %is_pos_inf1232 = and i1 %is_inf1230, %4857, !dbg !1113
  %is_neg_inf1233 = and i1 %is_inf1230, %4858, !dbg !1113
  %is_pos_max1234 = and i1 %is_maxfinite1231, %4857, !dbg !1113
  %is_neg_max1235 = and i1 %is_maxfinite1231, %4858, !dbg !1113
  %overflow_cond1236 = and i1 %4847, %is_inf1230, !dbg !1113
  br i1 %overflow_cond1236, label %4859, label %4861, !dbg !1113

4859:                                             ; preds = %4840
  %4860 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4861, !dbg !1113

4861:                                             ; preds = %4840, %4859
  %4862 = bitcast float %4758 to i32, !dbg !1113
  %4863 = and i32 %4862, 2139095040, !dbg !1113
  %4864 = icmp eq i32 %4863, 0, !dbg !1113
  %4865 = and i32 %4862, 8388607, !dbg !1113
  %4866 = icmp ne i32 %4865, 0, !dbg !1113
  %is_subnormal1237 = and i1 %4864, %4866, !dbg !1113
  %4867 = xor i1 %is_subnormal1237, true, !dbg !1113
  %4868 = and i1 true, %4867, !dbg !1113
  %4869 = bitcast float %4476 to i32, !dbg !1113
  %4870 = and i32 %4869, 2139095040, !dbg !1113
  %4871 = icmp eq i32 %4870, 0, !dbg !1113
  %4872 = and i32 %4869, 8388607, !dbg !1113
  %4873 = icmp ne i32 %4872, 0, !dbg !1113
  %is_subnormal1238 = and i1 %4871, %4873, !dbg !1113
  %4874 = xor i1 %is_subnormal1238, true, !dbg !1113
  %4875 = and i1 %4868, %4874, !dbg !1113
  %4876 = and i1 %4875, true, !dbg !1113
  %4877 = bitcast float %4841 to i32, !dbg !1113
  %4878 = and i32 %4877, 2139095040, !dbg !1113
  %4879 = icmp eq i32 %4878, 0, !dbg !1113
  %4880 = and i32 %4877, 8388607, !dbg !1113
  %4881 = icmp ne i32 %4880, 0, !dbg !1113
  %is_subnormal1239 = and i1 %4879, %4881, !dbg !1113
  %is_tiny1240 = or i1 %is_subnormal1239, false, !dbg !1113
  %underflow_cond1241 = and i1 %4876, %is_tiny1240, !dbg !1113
  br i1 %underflow_cond1241, label %4882, label %4884, !dbg !1113

4882:                                             ; preds = %4861
  %4883 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4884, !dbg !1113

4884:                                             ; preds = %4861, %4882
  %4885 = bitcast float %4841 to i32, !dbg !1113
  %4886 = bitcast float %4841 to i32, !dbg !1113
  %4887 = and i32 %4886, 2139095040, !dbg !1113
  %4888 = icmp eq i32 %4887, 2139095040, !dbg !1113
  %4889 = and i32 %4886, 8388607, !dbg !1113
  %4890 = icmp ne i32 %4889, 0, !dbg !1113
  %is_nan1242 = and i1 %4888, %4890, !dbg !1113
  %4891 = and i32 %4885, 4194304, !dbg !1113
  %4892 = icmp eq i32 %4891, 0, !dbg !1113
  %is_snan1243 = and i1 %is_nan1242, %4892, !dbg !1113
  %4893 = bitcast float %4476 to i32, !dbg !1113
  %4894 = bitcast float %4476 to i32, !dbg !1113
  %4895 = and i32 %4894, 2139095040, !dbg !1113
  %4896 = icmp eq i32 %4895, 2139095040, !dbg !1113
  %4897 = and i32 %4894, 8388607, !dbg !1113
  %4898 = icmp ne i32 %4897, 0, !dbg !1113
  %is_nan1244 = and i1 %4896, %4898, !dbg !1113
  %4899 = and i32 %4893, 4194304, !dbg !1113
  %4900 = icmp eq i32 %4899, 0, !dbg !1113
  %is_snan1245 = and i1 %is_nan1244, %4900, !dbg !1113
  %4901 = or i1 %is_snan1243, %is_snan1245, !dbg !1113
  %4902 = or i1 %4901, false, !dbg !1113
  %4903 = bitcast float %4841 to i32, !dbg !1113
  %4904 = and i32 %4903, 2147483647, !dbg !1113
  %is_zero1246 = icmp eq i32 %4904, 0, !dbg !1113
  %4905 = bitcast float %4476 to i32, !dbg !1113
  %4906 = and i32 %4905, 2139095040, !dbg !1113
  %4907 = icmp eq i32 %4906, 2139095040, !dbg !1113
  %4908 = and i32 %4905, 8388607, !dbg !1113
  %4909 = icmp eq i32 %4908, 0, !dbg !1113
  %is_inf1247 = and i1 %4907, %4909, !dbg !1113
  %4910 = and i1 %is_zero1246, %is_inf1247, !dbg !1113
  %4911 = bitcast float %4841 to i32, !dbg !1113
  %4912 = and i32 %4911, 2139095040, !dbg !1113
  %4913 = icmp eq i32 %4912, 2139095040, !dbg !1113
  %4914 = and i32 %4911, 8388607, !dbg !1113
  %4915 = icmp eq i32 %4914, 0, !dbg !1113
  %is_inf1248 = and i1 %4913, %4915, !dbg !1113
  %4916 = bitcast float %4476 to i32, !dbg !1113
  %4917 = and i32 %4916, 2147483647, !dbg !1113
  %is_zero1249 = icmp eq i32 %4917, 0, !dbg !1113
  %4918 = and i1 %is_inf1248, %is_zero1249, !dbg !1113
  %4919 = or i1 %4910, %4918, !dbg !1113
  %4920 = or i1 %4902, %4919, !dbg !1113
  br i1 %4920, label %4921, label %4923, !dbg !1113

4921:                                             ; preds = %4884
  %4922 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4923, !dbg !1113

4923:                                             ; preds = %4884, %4921
  %4924 = call float @llvm.nvvm.fma.rn.f(float %4841, float %4476, float 0xBFCFFFE440000000) #5, !dbg !1113
  %4925 = bitcast float %4841 to i32, !dbg !1113
  %4926 = and i32 %4925, 2139095040, !dbg !1113
  %is_finite1250 = icmp ne i32 %4926, 2139095040, !dbg !1113
  %4927 = and i1 true, %is_finite1250, !dbg !1113
  %4928 = bitcast float %4476 to i32, !dbg !1113
  %4929 = and i32 %4928, 2139095040, !dbg !1113
  %is_finite1251 = icmp ne i32 %4929, 2139095040, !dbg !1113
  %4930 = and i1 %4927, %is_finite1251, !dbg !1113
  %4931 = bitcast float %4924 to i32, !dbg !1113
  %4932 = and i32 %4931, 2139095040, !dbg !1113
  %4933 = icmp eq i32 %4932, 2139095040, !dbg !1113
  %4934 = and i32 %4931, 8388607, !dbg !1113
  %4935 = icmp eq i32 %4934, 0, !dbg !1113
  %is_inf1252 = and i1 %4933, %4935, !dbg !1113
  %4936 = bitcast float %4924 to i32, !dbg !1113
  %4937 = and i32 %4936, 2147483647, !dbg !1113
  %is_maxfinite1253 = icmp eq i32 %4937, 2139095039, !dbg !1113
  %4938 = bitcast float %4924 to i32, !dbg !1113
  %4939 = and i32 %4938, -2147483648, !dbg !1113
  %4940 = icmp eq i32 %4939, 0, !dbg !1113
  %4941 = icmp ne i32 %4939, 0, !dbg !1113
  %is_pos_inf1254 = and i1 %is_inf1252, %4940, !dbg !1113
  %is_neg_inf1255 = and i1 %is_inf1252, %4941, !dbg !1113
  %is_pos_max1256 = and i1 %is_maxfinite1253, %4940, !dbg !1113
  %is_neg_max1257 = and i1 %is_maxfinite1253, %4941, !dbg !1113
  %overflow_cond1258 = and i1 %4930, %is_inf1252, !dbg !1113
  br i1 %overflow_cond1258, label %4942, label %4944, !dbg !1113

4942:                                             ; preds = %4923
  %4943 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4944, !dbg !1113

4944:                                             ; preds = %4923, %4942
  %4945 = bitcast float %4841 to i32, !dbg !1113
  %4946 = and i32 %4945, 2139095040, !dbg !1113
  %4947 = icmp eq i32 %4946, 0, !dbg !1113
  %4948 = and i32 %4945, 8388607, !dbg !1113
  %4949 = icmp ne i32 %4948, 0, !dbg !1113
  %is_subnormal1259 = and i1 %4947, %4949, !dbg !1113
  %4950 = xor i1 %is_subnormal1259, true, !dbg !1113
  %4951 = and i1 true, %4950, !dbg !1113
  %4952 = bitcast float %4476 to i32, !dbg !1113
  %4953 = and i32 %4952, 2139095040, !dbg !1113
  %4954 = icmp eq i32 %4953, 0, !dbg !1113
  %4955 = and i32 %4952, 8388607, !dbg !1113
  %4956 = icmp ne i32 %4955, 0, !dbg !1113
  %is_subnormal1260 = and i1 %4954, %4956, !dbg !1113
  %4957 = xor i1 %is_subnormal1260, true, !dbg !1113
  %4958 = and i1 %4951, %4957, !dbg !1113
  %4959 = and i1 %4958, true, !dbg !1113
  %4960 = bitcast float %4924 to i32, !dbg !1113
  %4961 = and i32 %4960, 2139095040, !dbg !1113
  %4962 = icmp eq i32 %4961, 0, !dbg !1113
  %4963 = and i32 %4960, 8388607, !dbg !1113
  %4964 = icmp ne i32 %4963, 0, !dbg !1113
  %is_subnormal1261 = and i1 %4962, %4964, !dbg !1113
  %is_tiny1262 = or i1 %is_subnormal1261, false, !dbg !1113
  %underflow_cond1263 = and i1 %4959, %is_tiny1262, !dbg !1113
  br i1 %underflow_cond1263, label %4965, label %4967, !dbg !1113

4965:                                             ; preds = %4944
  %4966 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %4967, !dbg !1113

4967:                                             ; preds = %4944, %4965
  %4968 = bitcast float %4924 to i32, !dbg !1113
  %4969 = bitcast float %4924 to i32, !dbg !1113
  %4970 = and i32 %4969, 2139095040, !dbg !1113
  %4971 = icmp eq i32 %4970, 2139095040, !dbg !1113
  %4972 = and i32 %4969, 8388607, !dbg !1113
  %4973 = icmp ne i32 %4972, 0, !dbg !1113
  %is_nan1264 = and i1 %4971, %4973, !dbg !1113
  %4974 = and i32 %4968, 4194304, !dbg !1113
  %4975 = icmp eq i32 %4974, 0, !dbg !1113
  %is_snan1265 = and i1 %is_nan1264, %4975, !dbg !1113
  %4976 = bitcast float %4476 to i32, !dbg !1113
  %4977 = bitcast float %4476 to i32, !dbg !1113
  %4978 = and i32 %4977, 2139095040, !dbg !1113
  %4979 = icmp eq i32 %4978, 2139095040, !dbg !1113
  %4980 = and i32 %4977, 8388607, !dbg !1113
  %4981 = icmp ne i32 %4980, 0, !dbg !1113
  %is_nan1266 = and i1 %4979, %4981, !dbg !1113
  %4982 = and i32 %4976, 4194304, !dbg !1113
  %4983 = icmp eq i32 %4982, 0, !dbg !1113
  %is_snan1267 = and i1 %is_nan1266, %4983, !dbg !1113
  %4984 = or i1 %is_snan1265, %is_snan1267, !dbg !1113
  %4985 = or i1 %4984, false, !dbg !1113
  %4986 = bitcast float %4924 to i32, !dbg !1113
  %4987 = and i32 %4986, 2147483647, !dbg !1113
  %is_zero1268 = icmp eq i32 %4987, 0, !dbg !1113
  %4988 = bitcast float %4476 to i32, !dbg !1113
  %4989 = and i32 %4988, 2139095040, !dbg !1113
  %4990 = icmp eq i32 %4989, 2139095040, !dbg !1113
  %4991 = and i32 %4988, 8388607, !dbg !1113
  %4992 = icmp eq i32 %4991, 0, !dbg !1113
  %is_inf1269 = and i1 %4990, %4992, !dbg !1113
  %4993 = and i1 %is_zero1268, %is_inf1269, !dbg !1113
  %4994 = bitcast float %4924 to i32, !dbg !1113
  %4995 = and i32 %4994, 2139095040, !dbg !1113
  %4996 = icmp eq i32 %4995, 2139095040, !dbg !1113
  %4997 = and i32 %4994, 8388607, !dbg !1113
  %4998 = icmp eq i32 %4997, 0, !dbg !1113
  %is_inf1270 = and i1 %4996, %4998, !dbg !1113
  %4999 = bitcast float %4476 to i32, !dbg !1113
  %5000 = and i32 %4999, 2147483647, !dbg !1113
  %is_zero1271 = icmp eq i32 %5000, 0, !dbg !1113
  %5001 = and i1 %is_inf1270, %is_zero1271, !dbg !1113
  %5002 = or i1 %4993, %5001, !dbg !1113
  %5003 = or i1 %4985, %5002, !dbg !1113
  br i1 %5003, label %5004, label %5006, !dbg !1113

5004:                                             ; preds = %4967
  %5005 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5006, !dbg !1113

5006:                                             ; preds = %4967, %5004
  %5007 = call float @llvm.nvvm.fma.rn.f(float %4924, float %4476, float 0x3FD5554F00000000) #5, !dbg !1113
  %5008 = bitcast float %4924 to i32, !dbg !1113
  %5009 = and i32 %5008, 2139095040, !dbg !1113
  %is_finite1272 = icmp ne i32 %5009, 2139095040, !dbg !1113
  %5010 = and i1 true, %is_finite1272, !dbg !1113
  %5011 = bitcast float %4476 to i32, !dbg !1113
  %5012 = and i32 %5011, 2139095040, !dbg !1113
  %is_finite1273 = icmp ne i32 %5012, 2139095040, !dbg !1113
  %5013 = and i1 %5010, %is_finite1273, !dbg !1113
  %5014 = bitcast float %5007 to i32, !dbg !1113
  %5015 = and i32 %5014, 2139095040, !dbg !1113
  %5016 = icmp eq i32 %5015, 2139095040, !dbg !1113
  %5017 = and i32 %5014, 8388607, !dbg !1113
  %5018 = icmp eq i32 %5017, 0, !dbg !1113
  %is_inf1274 = and i1 %5016, %5018, !dbg !1113
  %5019 = bitcast float %5007 to i32, !dbg !1113
  %5020 = and i32 %5019, 2147483647, !dbg !1113
  %is_maxfinite1275 = icmp eq i32 %5020, 2139095039, !dbg !1113
  %5021 = bitcast float %5007 to i32, !dbg !1113
  %5022 = and i32 %5021, -2147483648, !dbg !1113
  %5023 = icmp eq i32 %5022, 0, !dbg !1113
  %5024 = icmp ne i32 %5022, 0, !dbg !1113
  %is_pos_inf1276 = and i1 %is_inf1274, %5023, !dbg !1113
  %is_neg_inf1277 = and i1 %is_inf1274, %5024, !dbg !1113
  %is_pos_max1278 = and i1 %is_maxfinite1275, %5023, !dbg !1113
  %is_neg_max1279 = and i1 %is_maxfinite1275, %5024, !dbg !1113
  %overflow_cond1280 = and i1 %5013, %is_inf1274, !dbg !1113
  br i1 %overflow_cond1280, label %5025, label %5027, !dbg !1113

5025:                                             ; preds = %5006
  %5026 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5027, !dbg !1113

5027:                                             ; preds = %5006, %5025
  %5028 = bitcast float %4924 to i32, !dbg !1113
  %5029 = and i32 %5028, 2139095040, !dbg !1113
  %5030 = icmp eq i32 %5029, 0, !dbg !1113
  %5031 = and i32 %5028, 8388607, !dbg !1113
  %5032 = icmp ne i32 %5031, 0, !dbg !1113
  %is_subnormal1281 = and i1 %5030, %5032, !dbg !1113
  %5033 = xor i1 %is_subnormal1281, true, !dbg !1113
  %5034 = and i1 true, %5033, !dbg !1113
  %5035 = bitcast float %4476 to i32, !dbg !1113
  %5036 = and i32 %5035, 2139095040, !dbg !1113
  %5037 = icmp eq i32 %5036, 0, !dbg !1113
  %5038 = and i32 %5035, 8388607, !dbg !1113
  %5039 = icmp ne i32 %5038, 0, !dbg !1113
  %is_subnormal1282 = and i1 %5037, %5039, !dbg !1113
  %5040 = xor i1 %is_subnormal1282, true, !dbg !1113
  %5041 = and i1 %5034, %5040, !dbg !1113
  %5042 = and i1 %5041, true, !dbg !1113
  %5043 = bitcast float %5007 to i32, !dbg !1113
  %5044 = and i32 %5043, 2139095040, !dbg !1113
  %5045 = icmp eq i32 %5044, 0, !dbg !1113
  %5046 = and i32 %5043, 8388607, !dbg !1113
  %5047 = icmp ne i32 %5046, 0, !dbg !1113
  %is_subnormal1283 = and i1 %5045, %5047, !dbg !1113
  %is_tiny1284 = or i1 %is_subnormal1283, false, !dbg !1113
  %underflow_cond1285 = and i1 %5042, %is_tiny1284, !dbg !1113
  br i1 %underflow_cond1285, label %5048, label %5050, !dbg !1113

5048:                                             ; preds = %5027
  %5049 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5050, !dbg !1113

5050:                                             ; preds = %5027, %5048
  %5051 = bitcast float %5007 to i32, !dbg !1113
  %5052 = bitcast float %5007 to i32, !dbg !1113
  %5053 = and i32 %5052, 2139095040, !dbg !1113
  %5054 = icmp eq i32 %5053, 2139095040, !dbg !1113
  %5055 = and i32 %5052, 8388607, !dbg !1113
  %5056 = icmp ne i32 %5055, 0, !dbg !1113
  %is_nan1286 = and i1 %5054, %5056, !dbg !1113
  %5057 = and i32 %5051, 4194304, !dbg !1113
  %5058 = icmp eq i32 %5057, 0, !dbg !1113
  %is_snan1287 = and i1 %is_nan1286, %5058, !dbg !1113
  %5059 = bitcast float %4476 to i32, !dbg !1113
  %5060 = bitcast float %4476 to i32, !dbg !1113
  %5061 = and i32 %5060, 2139095040, !dbg !1113
  %5062 = icmp eq i32 %5061, 2139095040, !dbg !1113
  %5063 = and i32 %5060, 8388607, !dbg !1113
  %5064 = icmp ne i32 %5063, 0, !dbg !1113
  %is_nan1288 = and i1 %5062, %5064, !dbg !1113
  %5065 = and i32 %5059, 4194304, !dbg !1113
  %5066 = icmp eq i32 %5065, 0, !dbg !1113
  %is_snan1289 = and i1 %is_nan1288, %5066, !dbg !1113
  %5067 = or i1 %is_snan1287, %is_snan1289, !dbg !1113
  %5068 = or i1 %5067, false, !dbg !1113
  %5069 = bitcast float %5007 to i32, !dbg !1113
  %5070 = and i32 %5069, 2147483647, !dbg !1113
  %is_zero1290 = icmp eq i32 %5070, 0, !dbg !1113
  %5071 = bitcast float %4476 to i32, !dbg !1113
  %5072 = and i32 %5071, 2139095040, !dbg !1113
  %5073 = icmp eq i32 %5072, 2139095040, !dbg !1113
  %5074 = and i32 %5071, 8388607, !dbg !1113
  %5075 = icmp eq i32 %5074, 0, !dbg !1113
  %is_inf1291 = and i1 %5073, %5075, !dbg !1113
  %5076 = and i1 %is_zero1290, %is_inf1291, !dbg !1113
  %5077 = bitcast float %5007 to i32, !dbg !1113
  %5078 = and i32 %5077, 2139095040, !dbg !1113
  %5079 = icmp eq i32 %5078, 2139095040, !dbg !1113
  %5080 = and i32 %5077, 8388607, !dbg !1113
  %5081 = icmp eq i32 %5080, 0, !dbg !1113
  %is_inf1292 = and i1 %5079, %5081, !dbg !1113
  %5082 = bitcast float %4476 to i32, !dbg !1113
  %5083 = and i32 %5082, 2147483647, !dbg !1113
  %is_zero1293 = icmp eq i32 %5083, 0, !dbg !1113
  %5084 = and i1 %is_inf1292, %is_zero1293, !dbg !1113
  %5085 = or i1 %5076, %5084, !dbg !1113
  %5086 = or i1 %5068, %5085, !dbg !1113
  br i1 %5086, label %5087, label %5089, !dbg !1113

5087:                                             ; preds = %5050
  %5088 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5089, !dbg !1113

5089:                                             ; preds = %5050, %5087
  %5090 = call float @llvm.nvvm.fma.rn.f(float %5007, float %4476, float -5.000000e-01) #5, !dbg !1113
  %5091 = bitcast float %5007 to i32, !dbg !1113
  %5092 = and i32 %5091, 2139095040, !dbg !1113
  %is_finite1294 = icmp ne i32 %5092, 2139095040, !dbg !1113
  %5093 = and i1 true, %is_finite1294, !dbg !1113
  %5094 = bitcast float %4476 to i32, !dbg !1113
  %5095 = and i32 %5094, 2139095040, !dbg !1113
  %is_finite1295 = icmp ne i32 %5095, 2139095040, !dbg !1113
  %5096 = and i1 %5093, %is_finite1295, !dbg !1113
  %5097 = bitcast float %5090 to i32, !dbg !1113
  %5098 = and i32 %5097, 2139095040, !dbg !1113
  %5099 = icmp eq i32 %5098, 2139095040, !dbg !1113
  %5100 = and i32 %5097, 8388607, !dbg !1113
  %5101 = icmp eq i32 %5100, 0, !dbg !1113
  %is_inf1296 = and i1 %5099, %5101, !dbg !1113
  %5102 = bitcast float %5090 to i32, !dbg !1113
  %5103 = and i32 %5102, 2147483647, !dbg !1113
  %is_maxfinite1297 = icmp eq i32 %5103, 2139095039, !dbg !1113
  %5104 = bitcast float %5090 to i32, !dbg !1113
  %5105 = and i32 %5104, -2147483648, !dbg !1113
  %5106 = icmp eq i32 %5105, 0, !dbg !1113
  %5107 = icmp ne i32 %5105, 0, !dbg !1113
  %is_pos_inf1298 = and i1 %is_inf1296, %5106, !dbg !1113
  %is_neg_inf1299 = and i1 %is_inf1296, %5107, !dbg !1113
  %is_pos_max1300 = and i1 %is_maxfinite1297, %5106, !dbg !1113
  %is_neg_max1301 = and i1 %is_maxfinite1297, %5107, !dbg !1113
  %overflow_cond1302 = and i1 %5096, %is_inf1296, !dbg !1113
  br i1 %overflow_cond1302, label %5108, label %5110, !dbg !1113

5108:                                             ; preds = %5089
  %5109 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5110, !dbg !1113

5110:                                             ; preds = %5089, %5108
  %5111 = bitcast float %5007 to i32, !dbg !1113
  %5112 = and i32 %5111, 2139095040, !dbg !1113
  %5113 = icmp eq i32 %5112, 0, !dbg !1113
  %5114 = and i32 %5111, 8388607, !dbg !1113
  %5115 = icmp ne i32 %5114, 0, !dbg !1113
  %is_subnormal1303 = and i1 %5113, %5115, !dbg !1113
  %5116 = xor i1 %is_subnormal1303, true, !dbg !1113
  %5117 = and i1 true, %5116, !dbg !1113
  %5118 = bitcast float %4476 to i32, !dbg !1113
  %5119 = and i32 %5118, 2139095040, !dbg !1113
  %5120 = icmp eq i32 %5119, 0, !dbg !1113
  %5121 = and i32 %5118, 8388607, !dbg !1113
  %5122 = icmp ne i32 %5121, 0, !dbg !1113
  %is_subnormal1304 = and i1 %5120, %5122, !dbg !1113
  %5123 = xor i1 %is_subnormal1304, true, !dbg !1113
  %5124 = and i1 %5117, %5123, !dbg !1113
  %5125 = and i1 %5124, true, !dbg !1113
  %5126 = bitcast float %5090 to i32, !dbg !1113
  %5127 = and i32 %5126, 2139095040, !dbg !1113
  %5128 = icmp eq i32 %5127, 0, !dbg !1113
  %5129 = and i32 %5126, 8388607, !dbg !1113
  %5130 = icmp ne i32 %5129, 0, !dbg !1113
  %is_subnormal1305 = and i1 %5128, %5130, !dbg !1113
  %is_tiny1306 = or i1 %is_subnormal1305, false, !dbg !1113
  %underflow_cond1307 = and i1 %5125, %is_tiny1306, !dbg !1113
  br i1 %underflow_cond1307, label %5131, label %5133, !dbg !1113

5131:                                             ; preds = %5110
  %5132 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5133, !dbg !1113

5133:                                             ; preds = %5110, %5131
  %5134 = bitcast float %5090 to i32, !dbg !1113
  %5135 = bitcast float %5090 to i32, !dbg !1113
  %5136 = and i32 %5135, 2139095040, !dbg !1113
  %5137 = icmp eq i32 %5136, 2139095040, !dbg !1113
  %5138 = and i32 %5135, 8388607, !dbg !1113
  %5139 = icmp ne i32 %5138, 0, !dbg !1113
  %is_nan1308 = and i1 %5137, %5139, !dbg !1113
  %5140 = and i32 %5134, 4194304, !dbg !1113
  %5141 = icmp eq i32 %5140, 0, !dbg !1113
  %is_snan1309 = and i1 %is_nan1308, %5141, !dbg !1113
  %5142 = bitcast float %4476 to i32, !dbg !1113
  %5143 = bitcast float %4476 to i32, !dbg !1113
  %5144 = and i32 %5143, 2139095040, !dbg !1113
  %5145 = icmp eq i32 %5144, 2139095040, !dbg !1113
  %5146 = and i32 %5143, 8388607, !dbg !1113
  %5147 = icmp ne i32 %5146, 0, !dbg !1113
  %is_nan1310 = and i1 %5145, %5147, !dbg !1113
  %5148 = and i32 %5142, 4194304, !dbg !1113
  %5149 = icmp eq i32 %5148, 0, !dbg !1113
  %is_snan1311 = and i1 %is_nan1310, %5149, !dbg !1113
  %5150 = or i1 %is_snan1309, %is_snan1311, !dbg !1113
  %5151 = bitcast float %5090 to i32, !dbg !1113
  %5152 = and i32 %5151, 2147483647, !dbg !1113
  %is_zero1312 = icmp eq i32 %5152, 0, !dbg !1113
  %5153 = bitcast float %4476 to i32, !dbg !1113
  %5154 = and i32 %5153, 2139095040, !dbg !1113
  %5155 = icmp eq i32 %5154, 2139095040, !dbg !1113
  %5156 = and i32 %5153, 8388607, !dbg !1113
  %5157 = icmp eq i32 %5156, 0, !dbg !1113
  %is_inf1313 = and i1 %5155, %5157, !dbg !1113
  %5158 = and i1 %is_zero1312, %is_inf1313, !dbg !1113
  %5159 = bitcast float %5090 to i32, !dbg !1113
  %5160 = and i32 %5159, 2139095040, !dbg !1113
  %5161 = icmp eq i32 %5160, 2139095040, !dbg !1113
  %5162 = and i32 %5159, 8388607, !dbg !1113
  %5163 = icmp eq i32 %5162, 0, !dbg !1113
  %is_inf1314 = and i1 %5161, %5163, !dbg !1113
  %5164 = bitcast float %4476 to i32, !dbg !1113
  %5165 = and i32 %5164, 2147483647, !dbg !1113
  %is_zero1315 = icmp eq i32 %5165, 0, !dbg !1113
  %5166 = and i1 %is_inf1314, %is_zero1315, !dbg !1113
  %5167 = or i1 %5158, %5166, !dbg !1113
  %5168 = or i1 %5150, %5167, !dbg !1113
  br i1 %5168, label %5169, label %5171, !dbg !1113

5169:                                             ; preds = %5133
  %5170 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5171, !dbg !1113

5171:                                             ; preds = %5133, %5169
  %5172 = fmul float %5090, %4476, !dbg !1113
  %5173 = bitcast float %5090 to i32, !dbg !1113
  %5174 = and i32 %5173, 2139095040, !dbg !1113
  %is_finite1316 = icmp ne i32 %5174, 2139095040, !dbg !1113
  %5175 = and i1 true, %is_finite1316, !dbg !1113
  %5176 = bitcast float %4476 to i32, !dbg !1113
  %5177 = and i32 %5176, 2139095040, !dbg !1113
  %is_finite1317 = icmp ne i32 %5177, 2139095040, !dbg !1113
  %5178 = and i1 %5175, %is_finite1317, !dbg !1113
  %5179 = bitcast float %5172 to i32, !dbg !1113
  %5180 = and i32 %5179, 2139095040, !dbg !1113
  %5181 = icmp eq i32 %5180, 2139095040, !dbg !1113
  %5182 = and i32 %5179, 8388607, !dbg !1113
  %5183 = icmp eq i32 %5182, 0, !dbg !1113
  %is_inf1318 = and i1 %5181, %5183, !dbg !1113
  %5184 = bitcast float %5172 to i32, !dbg !1113
  %5185 = and i32 %5184, 2147483647, !dbg !1113
  %is_maxfinite1319 = icmp eq i32 %5185, 2139095039, !dbg !1113
  %5186 = bitcast float %5172 to i32, !dbg !1113
  %5187 = and i32 %5186, -2147483648, !dbg !1113
  %5188 = icmp eq i32 %5187, 0, !dbg !1113
  %5189 = icmp ne i32 %5187, 0, !dbg !1113
  %is_pos_inf1320 = and i1 %is_inf1318, %5188, !dbg !1113
  %is_neg_inf1321 = and i1 %is_inf1318, %5189, !dbg !1113
  %is_pos_max1322 = and i1 %is_maxfinite1319, %5188, !dbg !1113
  %is_neg_max1323 = and i1 %is_maxfinite1319, %5189, !dbg !1113
  %overflow_cond1324 = and i1 %5178, %is_inf1318, !dbg !1113
  br i1 %overflow_cond1324, label %5190, label %5192, !dbg !1113

5190:                                             ; preds = %5171
  %5191 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5192, !dbg !1113

5192:                                             ; preds = %5171, %5190
  %5193 = bitcast float %5090 to i32, !dbg !1113
  %5194 = and i32 %5193, 2139095040, !dbg !1113
  %5195 = icmp eq i32 %5194, 0, !dbg !1113
  %5196 = and i32 %5193, 8388607, !dbg !1113
  %5197 = icmp ne i32 %5196, 0, !dbg !1113
  %is_subnormal1325 = and i1 %5195, %5197, !dbg !1113
  %5198 = xor i1 %is_subnormal1325, true, !dbg !1113
  %5199 = and i1 true, %5198, !dbg !1113
  %5200 = bitcast float %4476 to i32, !dbg !1113
  %5201 = and i32 %5200, 2139095040, !dbg !1113
  %5202 = icmp eq i32 %5201, 0, !dbg !1113
  %5203 = and i32 %5200, 8388607, !dbg !1113
  %5204 = icmp ne i32 %5203, 0, !dbg !1113
  %is_subnormal1326 = and i1 %5202, %5204, !dbg !1113
  %5205 = xor i1 %is_subnormal1326, true, !dbg !1113
  %5206 = and i1 %5199, %5205, !dbg !1113
  %5207 = bitcast float %5172 to i32, !dbg !1113
  %5208 = and i32 %5207, 2139095040, !dbg !1113
  %5209 = icmp eq i32 %5208, 0, !dbg !1113
  %5210 = and i32 %5207, 8388607, !dbg !1113
  %5211 = icmp ne i32 %5210, 0, !dbg !1113
  %is_subnormal1327 = and i1 %5209, %5211, !dbg !1113
  %5212 = bitcast float %5172 to i32, !dbg !1113
  %5213 = and i32 %5212, 2147483647, !dbg !1113
  %is_zero1328 = icmp eq i32 %5213, 0, !dbg !1113
  %5214 = bitcast float %5090 to i32, !dbg !1113
  %5215 = and i32 %5214, 2147483647, !dbg !1113
  %is_zero1329 = icmp eq i32 %5215, 0, !dbg !1113
  %5216 = xor i1 %is_zero1329, true, !dbg !1113
  %5217 = bitcast float %4476 to i32, !dbg !1113
  %5218 = and i32 %5217, 2147483647, !dbg !1113
  %is_zero1330 = icmp eq i32 %5218, 0, !dbg !1113
  %5219 = xor i1 %is_zero1330, true, !dbg !1113
  %5220 = and i1 %5216, %5219, !dbg !1113
  %5221 = and i1 %is_zero1328, %5220, !dbg !1113
  %is_tiny1331 = or i1 %is_subnormal1327, %5221, !dbg !1113
  %underflow_cond1332 = and i1 %5206, %is_tiny1331, !dbg !1113
  br i1 %underflow_cond1332, label %5222, label %5224, !dbg !1113

5222:                                             ; preds = %5192
  %5223 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5224, !dbg !1113

5224:                                             ; preds = %5192, %5222
  %5225 = bitcast float %5172 to i32, !dbg !1113
  %5226 = bitcast float %5172 to i32, !dbg !1113
  %5227 = and i32 %5226, 2139095040, !dbg !1113
  %5228 = icmp eq i32 %5227, 2139095040, !dbg !1113
  %5229 = and i32 %5226, 8388607, !dbg !1113
  %5230 = icmp ne i32 %5229, 0, !dbg !1113
  %is_nan1333 = and i1 %5228, %5230, !dbg !1113
  %5231 = and i32 %5225, 4194304, !dbg !1113
  %5232 = icmp eq i32 %5231, 0, !dbg !1113
  %is_snan1334 = and i1 %is_nan1333, %5232, !dbg !1113
  %5233 = bitcast float %4476 to i32, !dbg !1113
  %5234 = bitcast float %4476 to i32, !dbg !1113
  %5235 = and i32 %5234, 2139095040, !dbg !1113
  %5236 = icmp eq i32 %5235, 2139095040, !dbg !1113
  %5237 = and i32 %5234, 8388607, !dbg !1113
  %5238 = icmp ne i32 %5237, 0, !dbg !1113
  %is_nan1335 = and i1 %5236, %5238, !dbg !1113
  %5239 = and i32 %5233, 4194304, !dbg !1113
  %5240 = icmp eq i32 %5239, 0, !dbg !1113
  %is_snan1336 = and i1 %is_nan1335, %5240, !dbg !1113
  %5241 = or i1 %is_snan1334, %is_snan1336, !dbg !1113
  %5242 = bitcast float %4476 to i32, !dbg !1113
  %5243 = bitcast float %4476 to i32, !dbg !1113
  %5244 = and i32 %5243, 2139095040, !dbg !1113
  %5245 = icmp eq i32 %5244, 2139095040, !dbg !1113
  %5246 = and i32 %5243, 8388607, !dbg !1113
  %5247 = icmp ne i32 %5246, 0, !dbg !1113
  %is_nan1337 = and i1 %5245, %5247, !dbg !1113
  %5248 = and i32 %5242, 4194304, !dbg !1113
  %5249 = icmp eq i32 %5248, 0, !dbg !1113
  %is_snan1338 = and i1 %is_nan1337, %5249, !dbg !1113
  %5250 = or i1 %5241, %is_snan1338, !dbg !1113
  %5251 = bitcast float %5172 to i32, !dbg !1113
  %5252 = and i32 %5251, 2147483647, !dbg !1113
  %is_zero1339 = icmp eq i32 %5252, 0, !dbg !1113
  %5253 = bitcast float %4476 to i32, !dbg !1113
  %5254 = and i32 %5253, 2139095040, !dbg !1113
  %5255 = icmp eq i32 %5254, 2139095040, !dbg !1113
  %5256 = and i32 %5253, 8388607, !dbg !1113
  %5257 = icmp eq i32 %5256, 0, !dbg !1113
  %is_inf1340 = and i1 %5255, %5257, !dbg !1113
  %5258 = and i1 %is_zero1339, %is_inf1340, !dbg !1113
  %5259 = bitcast float %5172 to i32, !dbg !1113
  %5260 = and i32 %5259, 2139095040, !dbg !1113
  %5261 = icmp eq i32 %5260, 2139095040, !dbg !1113
  %5262 = and i32 %5259, 8388607, !dbg !1113
  %5263 = icmp eq i32 %5262, 0, !dbg !1113
  %is_inf1341 = and i1 %5261, %5263, !dbg !1113
  %5264 = bitcast float %4476 to i32, !dbg !1113
  %5265 = and i32 %5264, 2147483647, !dbg !1113
  %is_zero1342 = icmp eq i32 %5265, 0, !dbg !1113
  %5266 = and i1 %is_inf1341, %is_zero1342, !dbg !1113
  %5267 = or i1 %5258, %5266, !dbg !1113
  %5268 = or i1 %5250, %5267, !dbg !1113
  br i1 %5268, label %5269, label %5271, !dbg !1113

5269:                                             ; preds = %5224
  %5270 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5271, !dbg !1113

5271:                                             ; preds = %5224, %5269
  %5272 = call float @llvm.nvvm.fma.rn.f(float %5172, float %4476, float %4476) #5, !dbg !1113
  %5273 = bitcast float %5172 to i32, !dbg !1113
  %5274 = and i32 %5273, 2139095040, !dbg !1113
  %is_finite1343 = icmp ne i32 %5274, 2139095040, !dbg !1113
  %5275 = and i1 true, %is_finite1343, !dbg !1113
  %5276 = bitcast float %4476 to i32, !dbg !1113
  %5277 = and i32 %5276, 2139095040, !dbg !1113
  %is_finite1344 = icmp ne i32 %5277, 2139095040, !dbg !1113
  %5278 = and i1 %5275, %is_finite1344, !dbg !1113
  %5279 = bitcast float %5272 to i32, !dbg !1113
  %5280 = and i32 %5279, 2139095040, !dbg !1113
  %5281 = icmp eq i32 %5280, 2139095040, !dbg !1113
  %5282 = and i32 %5279, 8388607, !dbg !1113
  %5283 = icmp eq i32 %5282, 0, !dbg !1113
  %is_inf1345 = and i1 %5281, %5283, !dbg !1113
  %5284 = bitcast float %5272 to i32, !dbg !1113
  %5285 = and i32 %5284, 2147483647, !dbg !1113
  %is_maxfinite1346 = icmp eq i32 %5285, 2139095039, !dbg !1113
  %5286 = bitcast float %5272 to i32, !dbg !1113
  %5287 = and i32 %5286, -2147483648, !dbg !1113
  %5288 = icmp eq i32 %5287, 0, !dbg !1113
  %5289 = icmp ne i32 %5287, 0, !dbg !1113
  %is_pos_inf1347 = and i1 %is_inf1345, %5288, !dbg !1113
  %is_neg_inf1348 = and i1 %is_inf1345, %5289, !dbg !1113
  %is_pos_max1349 = and i1 %is_maxfinite1346, %5288, !dbg !1113
  %is_neg_max1350 = and i1 %is_maxfinite1346, %5289, !dbg !1113
  %overflow_cond1351 = and i1 %5278, %is_inf1345, !dbg !1113
  br i1 %overflow_cond1351, label %5290, label %5292, !dbg !1113

5290:                                             ; preds = %5271
  %5291 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5292, !dbg !1113

5292:                                             ; preds = %5271, %5290
  %5293 = bitcast float %5172 to i32, !dbg !1113
  %5294 = and i32 %5293, 2139095040, !dbg !1113
  %5295 = icmp eq i32 %5294, 0, !dbg !1113
  %5296 = and i32 %5293, 8388607, !dbg !1113
  %5297 = icmp ne i32 %5296, 0, !dbg !1113
  %is_subnormal1352 = and i1 %5295, %5297, !dbg !1113
  %5298 = xor i1 %is_subnormal1352, true, !dbg !1113
  %5299 = and i1 true, %5298, !dbg !1113
  %5300 = bitcast float %4476 to i32, !dbg !1113
  %5301 = and i32 %5300, 2139095040, !dbg !1113
  %5302 = icmp eq i32 %5301, 0, !dbg !1113
  %5303 = and i32 %5300, 8388607, !dbg !1113
  %5304 = icmp ne i32 %5303, 0, !dbg !1113
  %is_subnormal1353 = and i1 %5302, %5304, !dbg !1113
  %5305 = xor i1 %is_subnormal1353, true, !dbg !1113
  %5306 = and i1 %5299, %5305, !dbg !1113
  %5307 = bitcast float %4476 to i32, !dbg !1113
  %5308 = and i32 %5307, 2139095040, !dbg !1113
  %5309 = icmp eq i32 %5308, 0, !dbg !1113
  %5310 = and i32 %5307, 8388607, !dbg !1113
  %5311 = icmp ne i32 %5310, 0, !dbg !1113
  %is_subnormal1354 = and i1 %5309, %5311, !dbg !1113
  %5312 = xor i1 %is_subnormal1354, true, !dbg !1113
  %5313 = and i1 %5306, %5312, !dbg !1113
  %5314 = bitcast float %5272 to i32, !dbg !1113
  %5315 = and i32 %5314, 2139095040, !dbg !1113
  %5316 = icmp eq i32 %5315, 0, !dbg !1113
  %5317 = and i32 %5314, 8388607, !dbg !1113
  %5318 = icmp ne i32 %5317, 0, !dbg !1113
  %is_subnormal1355 = and i1 %5316, %5318, !dbg !1113
  %is_tiny1356 = or i1 %is_subnormal1355, false, !dbg !1113
  %underflow_cond1357 = and i1 %5313, %is_tiny1356, !dbg !1113
  br i1 %underflow_cond1357, label %5319, label %5321, !dbg !1113

5319:                                             ; preds = %5292
  %5320 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5321, !dbg !1113

5321:                                             ; preds = %5292, %5319
  %5322 = bitcast float %4411 to i32, !dbg !1113
  %5323 = bitcast float %4411 to i32, !dbg !1113
  %5324 = and i32 %5323, 2139095040, !dbg !1113
  %5325 = icmp eq i32 %5324, 2139095040, !dbg !1113
  %5326 = and i32 %5323, 8388607, !dbg !1113
  %5327 = icmp ne i32 %5326, 0, !dbg !1113
  %is_nan1358 = and i1 %5325, %5327, !dbg !1113
  %5328 = and i32 %5322, 4194304, !dbg !1113
  %5329 = icmp eq i32 %5328, 0, !dbg !1113
  %is_snan1359 = and i1 %is_nan1358, %5329, !dbg !1113
  %5330 = or i1 %is_snan1359, false, !dbg !1113
  %5331 = bitcast float %5272 to i32, !dbg !1113
  %5332 = bitcast float %5272 to i32, !dbg !1113
  %5333 = and i32 %5332, 2139095040, !dbg !1113
  %5334 = icmp eq i32 %5333, 2139095040, !dbg !1113
  %5335 = and i32 %5332, 8388607, !dbg !1113
  %5336 = icmp ne i32 %5335, 0, !dbg !1113
  %is_nan1360 = and i1 %5334, %5336, !dbg !1113
  %5337 = and i32 %5331, 4194304, !dbg !1113
  %5338 = icmp eq i32 %5337, 0, !dbg !1113
  %is_snan1361 = and i1 %is_nan1360, %5338, !dbg !1113
  %5339 = or i1 %5330, %is_snan1361, !dbg !1113
  %5340 = bitcast float %4411 to i32, !dbg !1113
  %5341 = and i32 %5340, 2147483647, !dbg !1113
  %is_zero1362 = icmp eq i32 %5341, 0, !dbg !1113
  %5342 = and i1 %is_zero1362, false, !dbg !1113
  %5343 = bitcast float %4411 to i32, !dbg !1113
  %5344 = and i32 %5343, 2139095040, !dbg !1113
  %5345 = icmp eq i32 %5344, 2139095040, !dbg !1113
  %5346 = and i32 %5343, 8388607, !dbg !1113
  %5347 = icmp eq i32 %5346, 0, !dbg !1113
  %is_inf1363 = and i1 %5345, %5347, !dbg !1113
  %5348 = and i1 %is_inf1363, false, !dbg !1113
  %5349 = or i1 %5342, %5348, !dbg !1113
  %5350 = or i1 %5339, %5349, !dbg !1113
  br i1 %5350, label %5351, label %5353, !dbg !1113

5351:                                             ; preds = %5321
  %5352 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5353, !dbg !1113

5353:                                             ; preds = %5321, %5351
  %5354 = call float @llvm.nvvm.fma.rn.f(float %4411, float 0x3FE62E4300000000, float %5272) #5, !dbg !1113
  %5355 = bitcast float %4411 to i32, !dbg !1113
  %5356 = and i32 %5355, 2139095040, !dbg !1113
  %is_finite1364 = icmp ne i32 %5356, 2139095040, !dbg !1113
  %5357 = and i1 true, %is_finite1364, !dbg !1113
  %5358 = and i1 %5357, true, !dbg !1113
  %5359 = bitcast float %5354 to i32, !dbg !1113
  %5360 = and i32 %5359, 2139095040, !dbg !1113
  %5361 = icmp eq i32 %5360, 2139095040, !dbg !1113
  %5362 = and i32 %5359, 8388607, !dbg !1113
  %5363 = icmp eq i32 %5362, 0, !dbg !1113
  %is_inf1365 = and i1 %5361, %5363, !dbg !1113
  %5364 = bitcast float %5354 to i32, !dbg !1113
  %5365 = and i32 %5364, 2147483647, !dbg !1113
  %is_maxfinite1366 = icmp eq i32 %5365, 2139095039, !dbg !1113
  %5366 = bitcast float %5354 to i32, !dbg !1113
  %5367 = and i32 %5366, -2147483648, !dbg !1113
  %5368 = icmp eq i32 %5367, 0, !dbg !1113
  %5369 = icmp ne i32 %5367, 0, !dbg !1113
  %is_pos_inf1367 = and i1 %is_inf1365, %5368, !dbg !1113
  %is_neg_inf1368 = and i1 %is_inf1365, %5369, !dbg !1113
  %is_pos_max1369 = and i1 %is_maxfinite1366, %5368, !dbg !1113
  %is_neg_max1370 = and i1 %is_maxfinite1366, %5369, !dbg !1113
  %overflow_cond1371 = and i1 %5358, %is_inf1365, !dbg !1113
  br i1 %overflow_cond1371, label %5370, label %5372, !dbg !1113

5370:                                             ; preds = %5353
  %5371 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5372, !dbg !1113

5372:                                             ; preds = %5353, %5370
  %5373 = bitcast float %4411 to i32, !dbg !1113
  %5374 = and i32 %5373, 2139095040, !dbg !1113
  %5375 = icmp eq i32 %5374, 0, !dbg !1113
  %5376 = and i32 %5373, 8388607, !dbg !1113
  %5377 = icmp ne i32 %5376, 0, !dbg !1113
  %is_subnormal1372 = and i1 %5375, %5377, !dbg !1113
  %5378 = xor i1 %is_subnormal1372, true, !dbg !1113
  %5379 = and i1 true, %5378, !dbg !1113
  %5380 = and i1 %5379, true, !dbg !1113
  %5381 = bitcast float %5272 to i32, !dbg !1113
  %5382 = and i32 %5381, 2139095040, !dbg !1113
  %5383 = icmp eq i32 %5382, 0, !dbg !1113
  %5384 = and i32 %5381, 8388607, !dbg !1113
  %5385 = icmp ne i32 %5384, 0, !dbg !1113
  %is_subnormal1373 = and i1 %5383, %5385, !dbg !1113
  %5386 = xor i1 %is_subnormal1373, true, !dbg !1113
  %5387 = and i1 %5380, %5386, !dbg !1113
  %5388 = bitcast float %5354 to i32, !dbg !1113
  %5389 = and i32 %5388, 2139095040, !dbg !1113
  %5390 = icmp eq i32 %5389, 0, !dbg !1113
  %5391 = and i32 %5388, 8388607, !dbg !1113
  %5392 = icmp ne i32 %5391, 0, !dbg !1113
  %is_subnormal1374 = and i1 %5390, %5392, !dbg !1113
  %is_tiny1375 = or i1 %is_subnormal1374, false, !dbg !1113
  %underflow_cond1376 = and i1 %5387, %is_tiny1375, !dbg !1113
  br i1 %underflow_cond1376, label %5393, label %5395, !dbg !1113

5393:                                             ; preds = %5372
  %5394 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5395, !dbg !1113

5395:                                             ; preds = %5372, %5393
  %5396 = bitcast float %.02.i to i32, !dbg !1113
  %5397 = icmp uge i32 %5396, 2139095040, !dbg !1113
  br i1 %5397, label %5398, label %5459, !dbg !1113

5398:                                             ; preds = %5395
  %5399 = bitcast float %.02.i to i32, !dbg !1113
  %5400 = bitcast float %.02.i to i32, !dbg !1113
  %5401 = and i32 %5400, 2139095040, !dbg !1113
  %5402 = icmp eq i32 %5401, 2139095040, !dbg !1113
  %5403 = and i32 %5400, 8388607, !dbg !1113
  %5404 = icmp ne i32 %5403, 0, !dbg !1113
  %is_nan1377 = and i1 %5402, %5404, !dbg !1113
  %5405 = and i32 %5399, 4194304, !dbg !1113
  %5406 = icmp eq i32 %5405, 0, !dbg !1113
  %is_snan1378 = and i1 %is_nan1377, %5406, !dbg !1113
  %5407 = or i1 %is_snan1378, false, !dbg !1113
  %5408 = or i1 %5407, false, !dbg !1113
  %5409 = bitcast float %.02.i to i32, !dbg !1113
  %5410 = and i32 %5409, 2147483647, !dbg !1113
  %is_zero1379 = icmp eq i32 %5410, 0, !dbg !1113
  %5411 = and i1 %is_zero1379, true, !dbg !1113
  %5412 = bitcast float %.02.i to i32, !dbg !1113
  %5413 = and i32 %5412, 2139095040, !dbg !1113
  %5414 = icmp eq i32 %5413, 2139095040, !dbg !1113
  %5415 = and i32 %5412, 8388607, !dbg !1113
  %5416 = icmp eq i32 %5415, 0, !dbg !1113
  %is_inf1380 = and i1 %5414, %5416, !dbg !1113
  %5417 = and i1 %is_inf1380, false, !dbg !1113
  %5418 = or i1 %5411, %5417, !dbg !1113
  %5419 = or i1 %5408, %5418, !dbg !1113
  br i1 %5419, label %5420, label %5422, !dbg !1113

5420:                                             ; preds = %5398
  %5421 = atomicrmw add ptr addrspace(1) @fp_invalid_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5422, !dbg !1113

5422:                                             ; preds = %5398, %5420
  %5423 = call float @llvm.nvvm.fma.rn.f(float %.02.i, float 0x7FF0000000000000, float 0x7FF0000000000000) #5, !dbg !1113
  %5424 = bitcast float %.02.i to i32, !dbg !1113
  %5425 = and i32 %5424, 2139095040, !dbg !1113
  %is_finite1381 = icmp ne i32 %5425, 2139095040, !dbg !1113
  %5426 = and i1 true, %is_finite1381, !dbg !1113
  %5427 = and i1 %5426, false, !dbg !1113
  %5428 = bitcast float %5423 to i32, !dbg !1113
  %5429 = and i32 %5428, 2139095040, !dbg !1113
  %5430 = icmp eq i32 %5429, 2139095040, !dbg !1113
  %5431 = and i32 %5428, 8388607, !dbg !1113
  %5432 = icmp eq i32 %5431, 0, !dbg !1113
  %is_inf1382 = and i1 %5430, %5432, !dbg !1113
  %5433 = bitcast float %5423 to i32, !dbg !1113
  %5434 = and i32 %5433, 2147483647, !dbg !1113
  %is_maxfinite1383 = icmp eq i32 %5434, 2139095039, !dbg !1113
  %5435 = bitcast float %5423 to i32, !dbg !1113
  %5436 = and i32 %5435, -2147483648, !dbg !1113
  %5437 = icmp eq i32 %5436, 0, !dbg !1113
  %5438 = icmp ne i32 %5436, 0, !dbg !1113
  %is_pos_inf1384 = and i1 %is_inf1382, %5437, !dbg !1113
  %is_neg_inf1385 = and i1 %is_inf1382, %5438, !dbg !1113
  %is_pos_max1386 = and i1 %is_maxfinite1383, %5437, !dbg !1113
  %is_neg_max1387 = and i1 %is_maxfinite1383, %5438, !dbg !1113
  %overflow_cond1388 = and i1 %5427, %is_inf1382, !dbg !1113
  br i1 %overflow_cond1388, label %5439, label %5441, !dbg !1113

5439:                                             ; preds = %5422
  %5440 = atomicrmw add ptr addrspace(1) @fp_overflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5441, !dbg !1113

5441:                                             ; preds = %5422, %5439
  %5442 = bitcast float %.02.i to i32, !dbg !1113
  %5443 = and i32 %5442, 2139095040, !dbg !1113
  %5444 = icmp eq i32 %5443, 0, !dbg !1113
  %5445 = and i32 %5442, 8388607, !dbg !1113
  %5446 = icmp ne i32 %5445, 0, !dbg !1113
  %is_subnormal1389 = and i1 %5444, %5446, !dbg !1113
  %5447 = xor i1 %is_subnormal1389, true, !dbg !1113
  %5448 = and i1 true, %5447, !dbg !1113
  %5449 = and i1 %5448, true, !dbg !1113
  %5450 = and i1 %5449, true, !dbg !1113
  %5451 = bitcast float %5423 to i32, !dbg !1113
  %5452 = and i32 %5451, 2139095040, !dbg !1113
  %5453 = icmp eq i32 %5452, 0, !dbg !1113
  %5454 = and i32 %5451, 8388607, !dbg !1113
  %5455 = icmp ne i32 %5454, 0, !dbg !1113
  %is_subnormal1390 = and i1 %5453, %5455, !dbg !1113
  %is_tiny1391 = or i1 %is_subnormal1390, false, !dbg !1113
  %underflow_cond1392 = and i1 %5450, %is_tiny1391, !dbg !1113
  br i1 %underflow_cond1392, label %5456, label %5458, !dbg !1113

5456:                                             ; preds = %5441
  %5457 = atomicrmw add ptr addrspace(1) @fp_underflow_counter, i64 1 monotonic, align 8, !dbg !1113
  br label %5458, !dbg !1113

5458:                                             ; preds = %5441, %5456
  br label %5459, !dbg !1113

5459:                                             ; preds = %5458, %5395
  %r.i.0.i = phi float [ %5423, %5458 ], [ %5354, %5395 ], !dbg !1113
  %5460 = fcmp oeq float %.02.i, 0.000000e+00, !dbg !1113
  br i1 %5460, label %5461, label %__nv_logf.exit, !dbg !1113

5461:                                             ; preds = %5459
  br label %__nv_logf.exit, !dbg !1113

__nv_logf.exit:                                   ; preds = %5459, %5461
  %r.i.1.i = phi float [ 0xFFF0000000000000, %5461 ], [ %r.i.0.i, %5459 ], !dbg !1113
  %5462 = load ptr, ptr %result.addr, align 8, !dbg !1114
  %arrayidx58 = getelementptr inbounds float, ptr %5462, i64 7, !dbg !1114
  store float %r.i.1.i, ptr %arrayidx58, align 4, !dbg !1115
  %5463 = load ptr, ptr %result.addr, align 8, !dbg !1116
  %arrayidx59 = getelementptr inbounds float, ptr %5463, i64 7, !dbg !1116
  %5464 = load float, ptr %arrayidx59, align 4, !dbg !1116
  %call60 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %5464) #4, !dbg !1117
  %5465 = zext i1 %call60 to i64, !dbg !1117
  %cond61 = select i1 %call60, i32 1, i32 0, !dbg !1117
  %5466 = load ptr, ptr %is_denorm.addr, align 8, !dbg !1118
  %arrayidx62 = getelementptr inbounds i32, ptr %5466, i64 7, !dbg !1118
  store i32 %cond61, ptr %arrayidx62, align 4, !dbg !1119
  br label %if.end63, !dbg !1120

if.end63:                                         ; preds = %__nv_logf.exit, %if.end54
  ret void, !dbg !1121
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.sqrt.approx.f(float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fma.rn.f(float, float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.saturate.f(float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fma.rm.f(float, float, float) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare float @llvm.nvvm.ex2.approx.ftz.f32(float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.trunc.f(float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.mul.rn.f(float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.add.rn.f(float, float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.round.f(float) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.floor.f(float) #1

attributes #0 = { convergent noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { convergent noinline norecurse nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" "uniform-work-group-size"="true" }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #4 = { convergent nounwind }
attributes #5 = { nounwind }
attributes #6 = { nounwind memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!954, !955}
!nvvmir.version = !{!956}
!llvm.module.flags = !{!957, !958, !959, !960, !961, !962}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !27, imports: !91, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "tests/basic_tests/underflow/basic.cu", directory: "/home/users/sislam3/SBAC-PAD")
!2 = !{!3}
!3 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "sm_selector", scope: !5, file: !4, line: 84, baseType: !8, size: 64, flags: DIFlagEnumClass, elements: !10, identifier: "_ZTSN2nv6target6detail11sm_selectorE")
!4 = !DIFile(filename: "/storage/packages/cuda/12.8.1/include/nv/target", directory: "")
!5 = !DINamespace(name: "detail", scope: !6)
!6 = !DINamespace(name: "target", scope: !7)
!7 = !DINamespace(name: "nv", scope: null)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "base_int_t", scope: !5, file: !4, line: 47, baseType: !9)
!9 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!10 = !{!11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26}
!11 = !DIEnumerator(name: "sm_35", value: 35, isUnsigned: true)
!12 = !DIEnumerator(name: "sm_37", value: 37, isUnsigned: true)
!13 = !DIEnumerator(name: "sm_50", value: 50, isUnsigned: true)
!14 = !DIEnumerator(name: "sm_52", value: 52, isUnsigned: true)
!15 = !DIEnumerator(name: "sm_53", value: 53, isUnsigned: true)
!16 = !DIEnumerator(name: "sm_60", value: 60, isUnsigned: true)
!17 = !DIEnumerator(name: "sm_61", value: 61, isUnsigned: true)
!18 = !DIEnumerator(name: "sm_62", value: 62, isUnsigned: true)
!19 = !DIEnumerator(name: "sm_70", value: 70, isUnsigned: true)
!20 = !DIEnumerator(name: "sm_72", value: 72, isUnsigned: true)
!21 = !DIEnumerator(name: "sm_75", value: 75, isUnsigned: true)
!22 = !DIEnumerator(name: "sm_80", value: 80, isUnsigned: true)
!23 = !DIEnumerator(name: "sm_86", value: 86, isUnsigned: true)
!24 = !DIEnumerator(name: "sm_87", value: 87, isUnsigned: true)
!25 = !DIEnumerator(name: "sm_89", value: 89, isUnsigned: true)
!26 = !DIEnumerator(name: "sm_90", value: 90, isUnsigned: true)
!27 = !{!28, !35, !60}
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "target_description", scope: !5, file: !4, line: 74, size: 64, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !29, identifier: "_ZTSN2nv6target6detail18target_descriptionE")
!29 = !{!30, !31}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "targets", scope: !28, file: !4, line: 76, baseType: !8, size: 64)
!31 = !DISubprogram(name: "target_description", linkageName: "_ZN2nv6target6detail18target_descriptionC4Ey", scope: !28, file: !4, line: 78, type: !32, scopeLine: 78, flags: DIFlagPrototyped, spFlags: 0)
!32 = !DISubroutineType(types: !33)
!33 = !{null, !34, !8}
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "dim3", file: !36, line: 426, size: 96, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !37, identifier: "_ZTS4dim3")
!36 = !DIFile(filename: "/storage/packages/cuda/12.8.1/include/vector_types.h", directory: "")
!37 = !{!38, !40, !41, !42, !46, !55}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !35, file: !36, line: 428, baseType: !39, size: 32)
!39 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !35, file: !36, line: 428, baseType: !39, size: 32, offset: 32)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !35, file: !36, line: 428, baseType: !39, size: 32, offset: 64)
!42 = !DISubprogram(name: "dim3", linkageName: "_ZN4dim3C4Ejjj", scope: !35, file: !36, line: 431, type: !43, scopeLine: 431, flags: DIFlagPrototyped, spFlags: 0)
!43 = !DISubroutineType(types: !44)
!44 = !{null, !45, !39, !39, !39}
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!46 = !DISubprogram(name: "dim3", linkageName: "_ZN4dim3C4E5uint3", scope: !35, file: !36, line: 432, type: !47, scopeLine: 432, flags: DIFlagPrototyped, spFlags: 0)
!47 = !DISubroutineType(types: !48)
!48 = !{null, !45, !49}
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint3", file: !36, line: 388, baseType: !50)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "uint3", file: !36, line: 196, size: 96, flags: DIFlagTypePassByValue, elements: !51, identifier: "_ZTS5uint3")
!51 = !{!52, !53, !54}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !50, file: !36, line: 198, baseType: !39, size: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !50, file: !36, line: 198, baseType: !39, size: 32, offset: 32)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !50, file: !36, line: 198, baseType: !39, size: 32, offset: 64)
!55 = !DISubprogram(name: "operator uint3", linkageName: "_ZNK4dim3cv5uint3Ev", scope: !35, file: !36, line: 433, type: !56, scopeLine: 433, flags: DIFlagPrototyped, spFlags: 0)
!56 = !DISubroutineType(types: !57)
!57 = !{!49, !58}
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!59 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!60 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__cuda_builtin_threadIdx_t", file: !61, line: 52, size: 8, flags: DIFlagTypePassByReference, elements: !62, identifier: "_ZTS26__cuda_builtin_threadIdx_t")
!61 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_builtin_vars.h", directory: "")
!62 = !{!63, !66, !67, !68, !73, !76, !80, !84, !87}
!63 = !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !60, file: !61, line: 53, type: !64, scopeLine: 53, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!64 = !DISubroutineType(types: !65)
!65 = !{!39}
!66 = !DISubprogram(name: "__fetch_builtin_y", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_yEv", scope: !60, file: !61, line: 54, type: !64, scopeLine: 54, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!67 = !DISubprogram(name: "__fetch_builtin_z", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_zEv", scope: !60, file: !61, line: 55, type: !64, scopeLine: 55, flags: DIFlagPrototyped | DIFlagStaticMember, spFlags: 0)
!68 = !DISubprogram(name: "operator dim3", linkageName: "_ZNK26__cuda_builtin_threadIdx_tcv4dim3Ev", scope: !60, file: !61, line: 58, type: !69, scopeLine: 58, flags: DIFlagPrototyped, spFlags: 0)
!69 = !DISubroutineType(types: !70)
!70 = !{!35, !71}
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!72 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !60)
!73 = !DISubprogram(name: "operator uint3", linkageName: "_ZNK26__cuda_builtin_threadIdx_tcv5uint3Ev", scope: !60, file: !61, line: 59, type: !74, scopeLine: 59, flags: DIFlagPrototyped, spFlags: 0)
!74 = !DISubroutineType(types: !75)
!75 = !{!50, !71}
!76 = !DISubprogram(name: "__cuda_builtin_threadIdx_t", linkageName: "_ZN26__cuda_builtin_threadIdx_tC4Ev", scope: !60, file: !61, line: 62, type: !77, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!77 = !DISubroutineType(types: !78)
!78 = !{null, !79}
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!80 = !DISubprogram(name: "__cuda_builtin_threadIdx_t", linkageName: "_ZN26__cuda_builtin_threadIdx_tC4ERKS_", scope: !60, file: !61, line: 62, type: !81, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!81 = !DISubroutineType(types: !82)
!82 = !{null, !79, !83}
!83 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !72, size: 64)
!84 = !DISubprogram(name: "operator=", linkageName: "_ZNK26__cuda_builtin_threadIdx_taSERKS_", scope: !60, file: !61, line: 62, type: !85, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!85 = !DISubroutineType(types: !86)
!86 = !{null, !71, !83}
!87 = !DISubprogram(name: "operator&", linkageName: "_ZNK26__cuda_builtin_threadIdx_tadEv", scope: !60, file: !61, line: 62, type: !88, scopeLine: 62, flags: DIFlagPrivate | DIFlagPrototyped, spFlags: DISPFlagDeleted)
!88 = !DISubroutineType(types: !89)
!89 = !{!90, !71}
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!91 = !{!92, !99, !104, !106, !108, !110, !112, !116, !118, !120, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !148, !150, !152, !154, !158, !163, !165, !167, !172, !176, !178, !180, !182, !184, !186, !188, !190, !192, !197, !201, !203, !208, !212, !214, !216, !218, !220, !222, !226, !228, !230, !235, !243, !247, !249, !251, !253, !255, !259, !261, !263, !267, !269, !271, !273, !275, !277, !279, !281, !283, !285, !289, !295, !297, !299, !303, !305, !307, !309, !311, !313, !315, !317, !321, !325, !327, !329, !334, !336, !338, !340, !342, !344, !346, !349, !351, !353, !355, !360, !362, !364, !366, !368, !370, !372, !374, !376, !378, !380, !382, !386, !388, !390, !392, !394, !396, !398, !400, !402, !404, !406, !408, !410, !412, !414, !416, !420, !422, !426, !428, !430, !432, !434, !436, !438, !440, !442, !444, !448, !450, !454, !456, !458, !460, !464, !466, !470, !472, !474, !476, !478, !480, !482, !484, !486, !488, !490, !492, !494, !498, !500, !504, !506, !508, !510, !512, !514, !518, !520, !522, !524, !526, !528, !530, !534, !538, !540, !542, !544, !546, !550, !552, !556, !558, !560, !562, !564, !566, !568, !572, !574, !578, !580, !582, !586, !588, !590, !592, !594, !596, !598, !602, !606, !612, !616, !624, !629, !631, !633, !637, !641, !651, !653, !657, !661, !665, !670, !672, !676, !680, !684, !692, !696, !700, !702, !706, !710, !714, !720, !724, !728, !730, !738, !742, !749, !751, !753, !757, !761, !765, !769, !773, !777, !778, !779, !780, !782, !783, !784, !785, !786, !787, !788, !790, !791, !792, !793, !794, !795, !796, !797, !802, !803, !804, !805, !806, !807, !808, !809, !810, !811, !812, !813, !814, !815, !816, !817, !818, !819, !820, !821, !822, !823, !824, !825, !826, !830, !832, !834, !836, !838, !840, !842, !844, !846, !848, !850, !852, !854, !856, !858, !861, !863, !865, !867, !869, !871, !873, !875, !877, !879, !881, !883, !885, !887, !889, !891, !893, !895, !897, !899, !901, !903, !905, !907, !909, !911, !913, !915, !917, !919, !921, !923, !925, !927, !929, !931, !933, !935, !937, !939, !940, !941, !945, !947, !949}
!92 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !94, file: !95, line: 200)
!93 = !DINamespace(name: "std", scope: null)
!94 = !DISubprogram(name: "abs", linkageName: "_ZL3absi", scope: !95, file: !95, line: 30, type: !96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!95 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_math_forward_declares.h", directory: "")
!96 = !DISubroutineType(types: !97)
!97 = !{!98, !98}
!98 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !100, file: !95, line: 201)
!100 = !DISubprogram(name: "acos", linkageName: "_ZL4acosf", scope: !95, file: !95, line: 32, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!101 = !DISubroutineType(types: !102)
!102 = !{!103, !103}
!103 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !105, file: !95, line: 202)
!105 = !DISubprogram(name: "acosh", linkageName: "_ZL5acoshf", scope: !95, file: !95, line: 34, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !107, file: !95, line: 203)
!107 = !DISubprogram(name: "asin", linkageName: "_ZL4asinf", scope: !95, file: !95, line: 36, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !109, file: !95, line: 204)
!109 = !DISubprogram(name: "asinh", linkageName: "_ZL5asinhf", scope: !95, file: !95, line: 38, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !111, file: !95, line: 205)
!111 = !DISubprogram(name: "atan", linkageName: "_ZL4atanf", scope: !95, file: !95, line: 42, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !113, file: !95, line: 206)
!113 = !DISubprogram(name: "atan2", linkageName: "_ZL5atan2ff", scope: !95, file: !95, line: 40, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!114 = !DISubroutineType(types: !115)
!115 = !{!103, !103, !103}
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !117, file: !95, line: 207)
!117 = !DISubprogram(name: "atanh", linkageName: "_ZL5atanhf", scope: !95, file: !95, line: 44, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !119, file: !95, line: 208)
!119 = !DISubprogram(name: "cbrt", linkageName: "_ZL4cbrtf", scope: !95, file: !95, line: 46, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !121, file: !95, line: 209)
!121 = !DISubprogram(name: "ceil", linkageName: "_ZL4ceilf", scope: !95, file: !95, line: 48, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !123, file: !95, line: 210)
!123 = !DISubprogram(name: "copysign", linkageName: "_ZL8copysignff", scope: !95, file: !95, line: 50, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !125, file: !95, line: 211)
!125 = !DISubprogram(name: "cos", linkageName: "_ZL3cosf", scope: !95, file: !95, line: 52, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !127, file: !95, line: 212)
!127 = !DISubprogram(name: "cosh", linkageName: "_ZL4coshf", scope: !95, file: !95, line: 54, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !129, file: !95, line: 213)
!129 = !DISubprogram(name: "erf", linkageName: "_ZL3erff", scope: !95, file: !95, line: 58, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !131, file: !95, line: 214)
!131 = !DISubprogram(name: "erfc", linkageName: "_ZL4erfcf", scope: !95, file: !95, line: 56, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !133, file: !95, line: 215)
!133 = !DISubprogram(name: "exp", linkageName: "_ZL3expf", scope: !95, file: !95, line: 62, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !135, file: !95, line: 216)
!135 = !DISubprogram(name: "exp2", linkageName: "_ZL4exp2f", scope: !95, file: !95, line: 60, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !137, file: !95, line: 217)
!137 = !DISubprogram(name: "expm1", linkageName: "_ZL5expm1f", scope: !95, file: !95, line: 64, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !139, file: !95, line: 218)
!139 = !DISubprogram(name: "fabs", linkageName: "_ZL4fabsf", scope: !95, file: !95, line: 66, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !141, file: !95, line: 219)
!141 = !DISubprogram(name: "fdim", linkageName: "_ZL4fdimff", scope: !95, file: !95, line: 68, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !143, file: !95, line: 220)
!143 = !DISubprogram(name: "floor", linkageName: "_ZL5floorf", scope: !95, file: !95, line: 70, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !145, file: !95, line: 221)
!145 = !DISubprogram(name: "fma", linkageName: "_ZL3fmafff", scope: !95, file: !95, line: 72, type: !146, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!146 = !DISubroutineType(types: !147)
!147 = !{!103, !103, !103, !103}
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !149, file: !95, line: 222)
!149 = !DISubprogram(name: "fmax", linkageName: "_ZL4fmaxff", scope: !95, file: !95, line: 74, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !151, file: !95, line: 223)
!151 = !DISubprogram(name: "fmin", linkageName: "_ZL4fminff", scope: !95, file: !95, line: 76, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !153, file: !95, line: 224)
!153 = !DISubprogram(name: "fmod", linkageName: "_ZL4fmodff", scope: !95, file: !95, line: 78, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !155, file: !95, line: 225)
!155 = !DISubprogram(name: "fpclassify", linkageName: "_ZL10fpclassifyf", scope: !95, file: !95, line: 80, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!156 = !DISubroutineType(types: !157)
!157 = !{!98, !103}
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !159, file: !95, line: 226)
!159 = !DISubprogram(name: "frexp", linkageName: "_ZL5frexpfPi", scope: !95, file: !95, line: 82, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!160 = !DISubroutineType(types: !161)
!161 = !{!103, !103, !162}
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!163 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !164, file: !95, line: 227)
!164 = !DISubprogram(name: "hypot", linkageName: "_ZL5hypotff", scope: !95, file: !95, line: 84, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !166, file: !95, line: 228)
!166 = !DISubprogram(name: "ilogb", linkageName: "_ZL5ilogbf", scope: !95, file: !95, line: 86, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !168, file: !95, line: 229)
!168 = !DISubprogram(name: "isfinite", linkageName: "_ZL8isfinitef", scope: !95, file: !95, line: 91, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!169 = !DISubroutineType(types: !170)
!170 = !{!171, !103}
!171 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !173, file: !95, line: 230)
!173 = !DISubprogram(name: "isgreater", linkageName: "_ZL9isgreaterff", scope: !95, file: !95, line: 95, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!174 = !DISubroutineType(types: !175)
!175 = !{!171, !103, !103}
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !177, file: !95, line: 231)
!177 = !DISubprogram(name: "isgreaterequal", linkageName: "_ZL14isgreaterequalff", scope: !95, file: !95, line: 94, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !179, file: !95, line: 232)
!179 = !DISubprogram(name: "isinf", linkageName: "_ZL5isinff", scope: !95, file: !95, line: 100, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !181, file: !95, line: 233)
!181 = !DISubprogram(name: "isless", linkageName: "_ZL6islessff", scope: !95, file: !95, line: 104, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !183, file: !95, line: 234)
!183 = !DISubprogram(name: "islessequal", linkageName: "_ZL11islessequalff", scope: !95, file: !95, line: 103, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !185, file: !95, line: 235)
!185 = !DISubprogram(name: "islessgreater", linkageName: "_ZL13islessgreaterff", scope: !95, file: !95, line: 106, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !187, file: !95, line: 236)
!187 = !DISubprogram(name: "isnan", linkageName: "_ZL5isnanf", scope: !95, file: !95, line: 111, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !189, file: !95, line: 237)
!189 = !DISubprogram(name: "isnormal", linkageName: "_ZL8isnormalf", scope: !95, file: !95, line: 113, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!190 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !191, file: !95, line: 238)
!191 = !DISubprogram(name: "isunordered", linkageName: "_ZL11isunorderedff", scope: !95, file: !95, line: 115, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !193, file: !95, line: 239)
!193 = !DISubprogram(name: "labs", linkageName: "_ZL4labsl", scope: !95, file: !95, line: 116, type: !194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!194 = !DISubroutineType(types: !195)
!195 = !{!196, !196}
!196 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !198, file: !95, line: 240)
!198 = !DISubprogram(name: "ldexp", linkageName: "_ZL5ldexpfi", scope: !95, file: !95, line: 118, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!199 = !DISubroutineType(types: !200)
!200 = !{!103, !103, !98}
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !202, file: !95, line: 241)
!202 = !DISubprogram(name: "lgamma", linkageName: "_ZL6lgammaf", scope: !95, file: !95, line: 120, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !204, file: !95, line: 242)
!204 = !DISubprogram(name: "llabs", linkageName: "_ZL5llabsx", scope: !95, file: !95, line: 121, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!205 = !DISubroutineType(types: !206)
!206 = !{!207, !207}
!207 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !209, file: !95, line: 243)
!209 = !DISubprogram(name: "llrint", linkageName: "_ZL6llrintf", scope: !95, file: !95, line: 123, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!210 = !DISubroutineType(types: !211)
!211 = !{!207, !103}
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !213, file: !95, line: 244)
!213 = !DISubprogram(name: "log", linkageName: "_ZL3logf", scope: !95, file: !95, line: 133, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !215, file: !95, line: 245)
!215 = !DISubprogram(name: "log10", linkageName: "_ZL5log10f", scope: !95, file: !95, line: 125, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !217, file: !95, line: 246)
!217 = !DISubprogram(name: "log1p", linkageName: "_ZL5log1pf", scope: !95, file: !95, line: 127, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !219, file: !95, line: 247)
!219 = !DISubprogram(name: "log2", linkageName: "_ZL4log2f", scope: !95, file: !95, line: 129, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !221, file: !95, line: 248)
!221 = !DISubprogram(name: "logb", linkageName: "_ZL4logbf", scope: !95, file: !95, line: 131, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !223, file: !95, line: 249)
!223 = !DISubprogram(name: "lrint", linkageName: "_ZL5lrintf", scope: !95, file: !95, line: 135, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!224 = !DISubroutineType(types: !225)
!225 = !{!196, !103}
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !227, file: !95, line: 250)
!227 = !DISubprogram(name: "lround", linkageName: "_ZL6lroundf", scope: !95, file: !95, line: 137, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !229, file: !95, line: 251)
!229 = !DISubprogram(name: "llround", linkageName: "_ZL7llroundf", scope: !95, file: !95, line: 138, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !231, file: !95, line: 252)
!231 = !DISubprogram(name: "modf", linkageName: "_ZL4modffPf", scope: !95, file: !95, line: 140, type: !232, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!232 = !DISubroutineType(types: !233)
!233 = !{!103, !103, !234}
!234 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !236, file: !95, line: 253)
!236 = !DISubprogram(name: "nan", linkageName: "_ZL3nanPKc", scope: !95, file: !95, line: 141, type: !237, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!237 = !DISubroutineType(types: !238)
!238 = !{!239, !240}
!239 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!240 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !241, size: 64)
!241 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !242)
!242 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !244, file: !95, line: 254)
!244 = !DISubprogram(name: "nanf", linkageName: "_ZL4nanfPKc", scope: !95, file: !95, line: 142, type: !245, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!245 = !DISubroutineType(types: !246)
!246 = !{!103, !240}
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !248, file: !95, line: 255)
!248 = !DISubprogram(name: "nearbyint", linkageName: "_ZL9nearbyintf", scope: !95, file: !95, line: 144, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !250, file: !95, line: 256)
!250 = !DISubprogram(name: "nextafter", linkageName: "_ZL9nextafterff", scope: !95, file: !95, line: 146, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !252, file: !95, line: 257)
!252 = !DISubprogram(name: "pow", linkageName: "_ZL3powfi", scope: !95, file: !95, line: 150, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !254, file: !95, line: 258)
!254 = !DISubprogram(name: "remainder", linkageName: "_ZL9remainderff", scope: !95, file: !95, line: 152, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !256, file: !95, line: 259)
!256 = !DISubprogram(name: "remquo", linkageName: "_ZL6remquoffPi", scope: !95, file: !95, line: 154, type: !257, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!257 = !DISubroutineType(types: !258)
!258 = !{!103, !103, !103, !162}
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !260, file: !95, line: 260)
!260 = !DISubprogram(name: "rint", linkageName: "_ZL4rintf", scope: !95, file: !95, line: 156, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !262, file: !95, line: 261)
!262 = !DISubprogram(name: "round", linkageName: "_ZL5roundf", scope: !95, file: !95, line: 158, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !264, file: !95, line: 262)
!264 = !DISubprogram(name: "scalbln", linkageName: "_ZL7scalblnfl", scope: !95, file: !95, line: 160, type: !265, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!265 = !DISubroutineType(types: !266)
!266 = !{!103, !103, !196}
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !268, file: !95, line: 263)
!268 = !DISubprogram(name: "scalbn", linkageName: "_ZL6scalbnfi", scope: !95, file: !95, line: 162, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !270, file: !95, line: 264)
!270 = !DISubprogram(name: "signbit", linkageName: "_ZL7signbitf", scope: !95, file: !95, line: 167, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !272, file: !95, line: 265)
!272 = !DISubprogram(name: "sin", linkageName: "_ZL3sinf", scope: !95, file: !95, line: 169, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !274, file: !95, line: 266)
!274 = !DISubprogram(name: "sinh", linkageName: "_ZL4sinhf", scope: !95, file: !95, line: 171, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !276, file: !95, line: 267)
!276 = !DISubprogram(name: "sqrt", linkageName: "_ZL4sqrtf", scope: !95, file: !95, line: 173, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !278, file: !95, line: 268)
!278 = !DISubprogram(name: "tan", linkageName: "_ZL3tanf", scope: !95, file: !95, line: 175, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !280, file: !95, line: 269)
!280 = !DISubprogram(name: "tanh", linkageName: "_ZL4tanhf", scope: !95, file: !95, line: 177, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !282, file: !95, line: 270)
!282 = !DISubprogram(name: "tgamma", linkageName: "_ZL6tgammaf", scope: !95, file: !95, line: 179, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !284, file: !95, line: 271)
!284 = !DISubprogram(name: "trunc", linkageName: "_ZL5truncf", scope: !95, file: !95, line: 181, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !286, file: !288, line: 52)
!286 = !DISubprogram(name: "abs", scope: !287, file: !287, line: 837, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!287 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!288 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !290, file: !294, line: 85)
!290 = !DISubprogram(name: "acos", scope: !291, file: !291, line: 53, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!291 = !DIFile(filename: "/usr/include/bits/mathcalls.h", directory: "")
!292 = !DISubroutineType(types: !293)
!293 = !{!239, !239}
!294 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cmath", directory: "")
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !296, file: !294, line: 104)
!296 = !DISubprogram(name: "asin", scope: !291, file: !291, line: 55, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !298, file: !294, line: 123)
!298 = !DISubprogram(name: "atan", scope: !291, file: !291, line: 57, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !300, file: !294, line: 142)
!300 = !DISubprogram(name: "atan2", scope: !291, file: !291, line: 59, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!301 = !DISubroutineType(types: !302)
!302 = !{!239, !239, !239}
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !304, file: !294, line: 154)
!304 = !DISubprogram(name: "ceil", scope: !291, file: !291, line: 159, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !306, file: !294, line: 173)
!306 = !DISubprogram(name: "cos", scope: !291, file: !291, line: 62, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!307 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !308, file: !294, line: 192)
!308 = !DISubprogram(name: "cosh", scope: !291, file: !291, line: 71, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !310, file: !294, line: 211)
!310 = !DISubprogram(name: "exp", scope: !291, file: !291, line: 95, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!311 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !312, file: !294, line: 230)
!312 = !DISubprogram(name: "fabs", scope: !291, file: !291, line: 162, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !314, file: !294, line: 249)
!314 = !DISubprogram(name: "floor", scope: !291, file: !291, line: 165, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!315 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !316, file: !294, line: 268)
!316 = !DISubprogram(name: "fmod", scope: !291, file: !291, line: 168, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !318, file: !294, line: 280)
!318 = !DISubprogram(name: "frexp", scope: !291, file: !291, line: 98, type: !319, flags: DIFlagPrototyped, spFlags: 0)
!319 = !DISubroutineType(types: !320)
!320 = !{!239, !239, !162}
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !322, file: !294, line: 299)
!322 = !DISubprogram(name: "ldexp", scope: !291, file: !291, line: 101, type: !323, flags: DIFlagPrototyped, spFlags: 0)
!323 = !DISubroutineType(types: !324)
!324 = !{!239, !239, !98}
!325 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !326, file: !294, line: 318)
!326 = !DISubprogram(name: "log", scope: !291, file: !291, line: 104, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !328, file: !294, line: 337)
!328 = !DISubprogram(name: "log10", scope: !291, file: !291, line: 107, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !330, file: !294, line: 356)
!330 = !DISubprogram(name: "modf", scope: !291, file: !291, line: 110, type: !331, flags: DIFlagPrototyped, spFlags: 0)
!331 = !DISubroutineType(types: !332)
!332 = !{!239, !239, !333}
!333 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !239, size: 64)
!334 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !335, file: !294, line: 368)
!335 = !DISubprogram(name: "pow", scope: !291, file: !291, line: 140, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!336 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !337, file: !294, line: 396)
!337 = !DISubprogram(name: "sin", scope: !291, file: !291, line: 64, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !339, file: !294, line: 415)
!339 = !DISubprogram(name: "sinh", scope: !291, file: !291, line: 73, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!340 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !341, file: !294, line: 434)
!341 = !DISubprogram(name: "sqrt", scope: !291, file: !291, line: 143, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !343, file: !294, line: 453)
!343 = !DISubprogram(name: "tan", scope: !291, file: !291, line: 66, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !345, file: !294, line: 472)
!345 = !DISubprogram(name: "tanh", scope: !291, file: !291, line: 75, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!346 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !347, file: !294, line: 1881)
!347 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !348, line: 150, baseType: !239)
!348 = !DIFile(filename: "/usr/include/math.h", directory: "")
!349 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !350, file: !294, line: 1882)
!350 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !348, line: 149, baseType: !103)
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !352, file: !294, line: 1885)
!352 = !DISubprogram(name: "acosh", scope: !291, file: !291, line: 85, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!353 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !354, file: !294, line: 1886)
!354 = !DISubprogram(name: "acoshf", scope: !291, file: !291, line: 85, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!355 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !356, file: !294, line: 1887)
!356 = !DISubprogram(name: "acoshl", scope: !291, file: !291, line: 85, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!357 = !DISubroutineType(types: !358)
!358 = !{!359, !359}
!359 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!360 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !361, file: !294, line: 1889)
!361 = !DISubprogram(name: "asinh", scope: !291, file: !291, line: 87, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!362 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !363, file: !294, line: 1890)
!363 = !DISubprogram(name: "asinhf", scope: !291, file: !291, line: 87, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!364 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !365, file: !294, line: 1891)
!365 = !DISubprogram(name: "asinhl", scope: !291, file: !291, line: 87, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!366 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !367, file: !294, line: 1893)
!367 = !DISubprogram(name: "atanh", scope: !291, file: !291, line: 89, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!368 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !369, file: !294, line: 1894)
!369 = !DISubprogram(name: "atanhf", scope: !291, file: !291, line: 89, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!370 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !371, file: !294, line: 1895)
!371 = !DISubprogram(name: "atanhl", scope: !291, file: !291, line: 89, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!372 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !373, file: !294, line: 1897)
!373 = !DISubprogram(name: "cbrt", scope: !291, file: !291, line: 152, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!374 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !375, file: !294, line: 1898)
!375 = !DISubprogram(name: "cbrtf", scope: !291, file: !291, line: 152, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!376 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !377, file: !294, line: 1899)
!377 = !DISubprogram(name: "cbrtl", scope: !291, file: !291, line: 152, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!378 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !379, file: !294, line: 1901)
!379 = !DISubprogram(name: "copysign", scope: !291, file: !291, line: 196, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!380 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !381, file: !294, line: 1902)
!381 = !DISubprogram(name: "copysignf", scope: !291, file: !291, line: 196, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!382 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !383, file: !294, line: 1903)
!383 = !DISubprogram(name: "copysignl", scope: !291, file: !291, line: 196, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!384 = !DISubroutineType(types: !385)
!385 = !{!359, !359, !359}
!386 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !387, file: !294, line: 1905)
!387 = !DISubprogram(name: "erf", scope: !291, file: !291, line: 228, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!388 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !389, file: !294, line: 1906)
!389 = !DISubprogram(name: "erff", scope: !291, file: !291, line: 228, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!390 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !391, file: !294, line: 1907)
!391 = !DISubprogram(name: "erfl", scope: !291, file: !291, line: 228, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !393, file: !294, line: 1909)
!393 = !DISubprogram(name: "erfc", scope: !291, file: !291, line: 229, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!394 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !395, file: !294, line: 1910)
!395 = !DISubprogram(name: "erfcf", scope: !291, file: !291, line: 229, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!396 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !397, file: !294, line: 1911)
!397 = !DISubprogram(name: "erfcl", scope: !291, file: !291, line: 229, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!398 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !399, file: !294, line: 1913)
!399 = !DISubprogram(name: "exp2", scope: !291, file: !291, line: 130, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!400 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !401, file: !294, line: 1914)
!401 = !DISubprogram(name: "exp2f", scope: !291, file: !291, line: 130, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!402 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !403, file: !294, line: 1915)
!403 = !DISubprogram(name: "exp2l", scope: !291, file: !291, line: 130, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!404 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !405, file: !294, line: 1917)
!405 = !DISubprogram(name: "expm1", scope: !291, file: !291, line: 119, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!406 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !407, file: !294, line: 1918)
!407 = !DISubprogram(name: "expm1f", scope: !291, file: !291, line: 119, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !409, file: !294, line: 1919)
!409 = !DISubprogram(name: "expm1l", scope: !291, file: !291, line: 119, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!410 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !411, file: !294, line: 1921)
!411 = !DISubprogram(name: "fdim", scope: !291, file: !291, line: 326, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !413, file: !294, line: 1922)
!413 = !DISubprogram(name: "fdimf", scope: !291, file: !291, line: 326, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !415, file: !294, line: 1923)
!415 = !DISubprogram(name: "fdiml", scope: !291, file: !291, line: 326, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!416 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !417, file: !294, line: 1925)
!417 = !DISubprogram(name: "fma", scope: !291, file: !291, line: 335, type: !418, flags: DIFlagPrototyped, spFlags: 0)
!418 = !DISubroutineType(types: !419)
!419 = !{!239, !239, !239, !239}
!420 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !421, file: !294, line: 1926)
!421 = !DISubprogram(name: "fmaf", scope: !291, file: !291, line: 335, type: !146, flags: DIFlagPrototyped, spFlags: 0)
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !423, file: !294, line: 1927)
!423 = !DISubprogram(name: "fmal", scope: !291, file: !291, line: 335, type: !424, flags: DIFlagPrototyped, spFlags: 0)
!424 = !DISubroutineType(types: !425)
!425 = !{!359, !359, !359, !359}
!426 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !427, file: !294, line: 1929)
!427 = !DISubprogram(name: "fmax", scope: !291, file: !291, line: 329, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !429, file: !294, line: 1930)
!429 = !DISubprogram(name: "fmaxf", scope: !291, file: !291, line: 329, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!430 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !431, file: !294, line: 1931)
!431 = !DISubprogram(name: "fmaxl", scope: !291, file: !291, line: 329, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !433, file: !294, line: 1933)
!433 = !DISubprogram(name: "fmin", scope: !291, file: !291, line: 332, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !435, file: !294, line: 1934)
!435 = !DISubprogram(name: "fminf", scope: !291, file: !291, line: 332, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !437, file: !294, line: 1935)
!437 = !DISubprogram(name: "fminl", scope: !291, file: !291, line: 332, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!438 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !439, file: !294, line: 1937)
!439 = !DISubprogram(name: "hypot", scope: !291, file: !291, line: 147, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !441, file: !294, line: 1938)
!441 = !DISubprogram(name: "hypotf", scope: !291, file: !291, line: 147, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!442 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !443, file: !294, line: 1939)
!443 = !DISubprogram(name: "hypotl", scope: !291, file: !291, line: 147, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !445, file: !294, line: 1941)
!445 = !DISubprogram(name: "ilogb", scope: !291, file: !291, line: 280, type: !446, flags: DIFlagPrototyped, spFlags: 0)
!446 = !DISubroutineType(types: !447)
!447 = !{!98, !239}
!448 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !449, file: !294, line: 1942)
!449 = !DISubprogram(name: "ilogbf", scope: !291, file: !291, line: 280, type: !156, flags: DIFlagPrototyped, spFlags: 0)
!450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !451, file: !294, line: 1943)
!451 = !DISubprogram(name: "ilogbl", scope: !291, file: !291, line: 280, type: !452, flags: DIFlagPrototyped, spFlags: 0)
!452 = !DISubroutineType(types: !453)
!453 = !{!98, !359}
!454 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !455, file: !294, line: 1945)
!455 = !DISubprogram(name: "lgamma", scope: !291, file: !291, line: 230, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!456 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !457, file: !294, line: 1946)
!457 = !DISubprogram(name: "lgammaf", scope: !291, file: !291, line: 230, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!458 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !459, file: !294, line: 1947)
!459 = !DISubprogram(name: "lgammal", scope: !291, file: !291, line: 230, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!460 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !461, file: !294, line: 1950)
!461 = !DISubprogram(name: "llrint", scope: !291, file: !291, line: 316, type: !462, flags: DIFlagPrototyped, spFlags: 0)
!462 = !DISubroutineType(types: !463)
!463 = !{!207, !239}
!464 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !465, file: !294, line: 1951)
!465 = !DISubprogram(name: "llrintf", scope: !291, file: !291, line: 316, type: !210, flags: DIFlagPrototyped, spFlags: 0)
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !467, file: !294, line: 1952)
!467 = !DISubprogram(name: "llrintl", scope: !291, file: !291, line: 316, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!468 = !DISubroutineType(types: !469)
!469 = !{!207, !359}
!470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !471, file: !294, line: 1954)
!471 = !DISubprogram(name: "llround", scope: !291, file: !291, line: 322, type: !462, flags: DIFlagPrototyped, spFlags: 0)
!472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !473, file: !294, line: 1955)
!473 = !DISubprogram(name: "llroundf", scope: !291, file: !291, line: 322, type: !210, flags: DIFlagPrototyped, spFlags: 0)
!474 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !475, file: !294, line: 1956)
!475 = !DISubprogram(name: "llroundl", scope: !291, file: !291, line: 322, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !477, file: !294, line: 1959)
!477 = !DISubprogram(name: "log1p", scope: !291, file: !291, line: 122, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!478 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !479, file: !294, line: 1960)
!479 = !DISubprogram(name: "log1pf", scope: !291, file: !291, line: 122, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !481, file: !294, line: 1961)
!481 = !DISubprogram(name: "log1pl", scope: !291, file: !291, line: 122, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!482 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !483, file: !294, line: 1963)
!483 = !DISubprogram(name: "log2", scope: !291, file: !291, line: 133, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !485, file: !294, line: 1964)
!485 = !DISubprogram(name: "log2f", scope: !291, file: !291, line: 133, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !487, file: !294, line: 1965)
!487 = !DISubprogram(name: "log2l", scope: !291, file: !291, line: 133, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!488 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !489, file: !294, line: 1967)
!489 = !DISubprogram(name: "logb", scope: !291, file: !291, line: 125, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!490 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !491, file: !294, line: 1968)
!491 = !DISubprogram(name: "logbf", scope: !291, file: !291, line: 125, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!492 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !493, file: !294, line: 1969)
!493 = !DISubprogram(name: "logbl", scope: !291, file: !291, line: 125, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!494 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !495, file: !294, line: 1971)
!495 = !DISubprogram(name: "lrint", scope: !291, file: !291, line: 314, type: !496, flags: DIFlagPrototyped, spFlags: 0)
!496 = !DISubroutineType(types: !497)
!497 = !{!196, !239}
!498 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !499, file: !294, line: 1972)
!499 = !DISubprogram(name: "lrintf", scope: !291, file: !291, line: 314, type: !224, flags: DIFlagPrototyped, spFlags: 0)
!500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !501, file: !294, line: 1973)
!501 = !DISubprogram(name: "lrintl", scope: !291, file: !291, line: 314, type: !502, flags: DIFlagPrototyped, spFlags: 0)
!502 = !DISubroutineType(types: !503)
!503 = !{!196, !359}
!504 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !505, file: !294, line: 1975)
!505 = !DISubprogram(name: "lround", scope: !291, file: !291, line: 320, type: !496, flags: DIFlagPrototyped, spFlags: 0)
!506 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !507, file: !294, line: 1976)
!507 = !DISubprogram(name: "lroundf", scope: !291, file: !291, line: 320, type: !224, flags: DIFlagPrototyped, spFlags: 0)
!508 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !509, file: !294, line: 1977)
!509 = !DISubprogram(name: "lroundl", scope: !291, file: !291, line: 320, type: !502, flags: DIFlagPrototyped, spFlags: 0)
!510 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !511, file: !294, line: 1979)
!511 = !DISubprogram(name: "nan", scope: !291, file: !291, line: 201, type: !237, flags: DIFlagPrototyped, spFlags: 0)
!512 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !513, file: !294, line: 1980)
!513 = !DISubprogram(name: "nanf", scope: !291, file: !291, line: 201, type: !245, flags: DIFlagPrototyped, spFlags: 0)
!514 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !515, file: !294, line: 1981)
!515 = !DISubprogram(name: "nanl", scope: !291, file: !291, line: 201, type: !516, flags: DIFlagPrototyped, spFlags: 0)
!516 = !DISubroutineType(types: !517)
!517 = !{!359, !240}
!518 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !519, file: !294, line: 1983)
!519 = !DISubprogram(name: "nearbyint", scope: !291, file: !291, line: 294, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!520 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !521, file: !294, line: 1984)
!521 = !DISubprogram(name: "nearbyintf", scope: !291, file: !291, line: 294, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!522 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !523, file: !294, line: 1985)
!523 = !DISubprogram(name: "nearbyintl", scope: !291, file: !291, line: 294, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!524 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !525, file: !294, line: 1987)
!525 = !DISubprogram(name: "nextafter", scope: !291, file: !291, line: 259, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!526 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !527, file: !294, line: 1988)
!527 = !DISubprogram(name: "nextafterf", scope: !291, file: !291, line: 259, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!528 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !529, file: !294, line: 1989)
!529 = !DISubprogram(name: "nextafterl", scope: !291, file: !291, line: 259, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!530 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !531, file: !294, line: 1991)
!531 = !DISubprogram(name: "nexttoward", scope: !291, file: !291, line: 261, type: !532, flags: DIFlagPrototyped, spFlags: 0)
!532 = !DISubroutineType(types: !533)
!533 = !{!239, !239, !359}
!534 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !535, file: !294, line: 1992)
!535 = !DISubprogram(name: "nexttowardf", scope: !291, file: !291, line: 261, type: !536, flags: DIFlagPrototyped, spFlags: 0)
!536 = !DISubroutineType(types: !537)
!537 = !{!103, !103, !359}
!538 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !539, file: !294, line: 1993)
!539 = !DISubprogram(name: "nexttowardl", scope: !291, file: !291, line: 261, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!540 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !541, file: !294, line: 1995)
!541 = !DISubprogram(name: "remainder", scope: !291, file: !291, line: 272, type: !301, flags: DIFlagPrototyped, spFlags: 0)
!542 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !543, file: !294, line: 1996)
!543 = !DISubprogram(name: "remainderf", scope: !291, file: !291, line: 272, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !545, file: !294, line: 1997)
!545 = !DISubprogram(name: "remainderl", scope: !291, file: !291, line: 272, type: !384, flags: DIFlagPrototyped, spFlags: 0)
!546 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !547, file: !294, line: 1999)
!547 = !DISubprogram(name: "remquo", scope: !291, file: !291, line: 307, type: !548, flags: DIFlagPrototyped, spFlags: 0)
!548 = !DISubroutineType(types: !549)
!549 = !{!239, !239, !239, !162}
!550 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !551, file: !294, line: 2000)
!551 = !DISubprogram(name: "remquof", scope: !291, file: !291, line: 307, type: !257, flags: DIFlagPrototyped, spFlags: 0)
!552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !553, file: !294, line: 2001)
!553 = !DISubprogram(name: "remquol", scope: !291, file: !291, line: 307, type: !554, flags: DIFlagPrototyped, spFlags: 0)
!554 = !DISubroutineType(types: !555)
!555 = !{!359, !359, !359, !162}
!556 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !557, file: !294, line: 2003)
!557 = !DISubprogram(name: "rint", scope: !291, file: !291, line: 256, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!558 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !559, file: !294, line: 2004)
!559 = !DISubprogram(name: "rintf", scope: !291, file: !291, line: 256, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!560 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !561, file: !294, line: 2005)
!561 = !DISubprogram(name: "rintl", scope: !291, file: !291, line: 256, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!562 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !563, file: !294, line: 2007)
!563 = !DISubprogram(name: "round", scope: !291, file: !291, line: 298, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!564 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !565, file: !294, line: 2008)
!565 = !DISubprogram(name: "roundf", scope: !291, file: !291, line: 298, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!566 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !567, file: !294, line: 2009)
!567 = !DISubprogram(name: "roundl", scope: !291, file: !291, line: 298, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!568 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !569, file: !294, line: 2011)
!569 = !DISubprogram(name: "scalbln", scope: !291, file: !291, line: 290, type: !570, flags: DIFlagPrototyped, spFlags: 0)
!570 = !DISubroutineType(types: !571)
!571 = !{!239, !239, !196}
!572 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !573, file: !294, line: 2012)
!573 = !DISubprogram(name: "scalblnf", scope: !291, file: !291, line: 290, type: !265, flags: DIFlagPrototyped, spFlags: 0)
!574 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !575, file: !294, line: 2013)
!575 = !DISubprogram(name: "scalblnl", scope: !291, file: !291, line: 290, type: !576, flags: DIFlagPrototyped, spFlags: 0)
!576 = !DISubroutineType(types: !577)
!577 = !{!359, !359, !196}
!578 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !579, file: !294, line: 2015)
!579 = !DISubprogram(name: "scalbn", scope: !291, file: !291, line: 276, type: !323, flags: DIFlagPrototyped, spFlags: 0)
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !581, file: !294, line: 2016)
!581 = !DISubprogram(name: "scalbnf", scope: !291, file: !291, line: 276, type: !199, flags: DIFlagPrototyped, spFlags: 0)
!582 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !583, file: !294, line: 2017)
!583 = !DISubprogram(name: "scalbnl", scope: !291, file: !291, line: 276, type: !584, flags: DIFlagPrototyped, spFlags: 0)
!584 = !DISubroutineType(types: !585)
!585 = !{!359, !359, !98}
!586 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !587, file: !294, line: 2019)
!587 = !DISubprogram(name: "tgamma", scope: !291, file: !291, line: 235, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!588 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !589, file: !294, line: 2020)
!589 = !DISubprogram(name: "tgammaf", scope: !291, file: !291, line: 235, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!590 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !591, file: !294, line: 2021)
!591 = !DISubprogram(name: "tgammal", scope: !291, file: !291, line: 235, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!592 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !593, file: !294, line: 2023)
!593 = !DISubprogram(name: "trunc", scope: !291, file: !291, line: 302, type: !292, flags: DIFlagPrototyped, spFlags: 0)
!594 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !595, file: !294, line: 2024)
!595 = !DISubprogram(name: "truncf", scope: !291, file: !291, line: 302, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!596 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !597, file: !294, line: 2025)
!597 = !DISubprogram(name: "truncl", scope: !291, file: !291, line: 302, type: !357, flags: DIFlagPrototyped, spFlags: 0)
!598 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !599, entity: !600, file: !601, line: 58)
!599 = !DINamespace(name: "__gnu_debug", scope: null)
!600 = !DINamespace(name: "__debug", scope: !93)
!601 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/debug/debug.h", directory: "")
!602 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !603, file: !605, line: 131)
!603 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !287, line: 62, baseType: !604)
!604 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !287, line: 58, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!605 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/cstdlib", directory: "")
!606 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !607, file: !605, line: 132)
!607 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !287, line: 70, baseType: !608)
!608 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !287, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !609, identifier: "_ZTS6ldiv_t")
!609 = !{!610, !611}
!610 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !608, file: !287, line: 68, baseType: !196, size: 64)
!611 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !608, file: !287, line: 69, baseType: !196, size: 64, offset: 64)
!612 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !613, file: !605, line: 134)
!613 = !DISubprogram(name: "abort", scope: !287, file: !287, line: 588, type: !614, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!614 = !DISubroutineType(types: !615)
!615 = !{null}
!616 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !617, file: !605, line: 136)
!617 = !DISubprogram(name: "aligned_alloc", scope: !287, file: !287, line: 583, type: !618, flags: DIFlagPrototyped, spFlags: 0)
!618 = !DISubroutineType(types: !619)
!619 = !{!620, !621, !621}
!620 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!621 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !622, line: 18, baseType: !623)
!622 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__stddef_size_t.h", directory: "")
!623 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!624 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !625, file: !605, line: 138)
!625 = !DISubprogram(name: "atexit", scope: !287, file: !287, line: 592, type: !626, flags: DIFlagPrototyped, spFlags: 0)
!626 = !DISubroutineType(types: !627)
!627 = !{!98, !628}
!628 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !614, size: 64)
!629 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !630, file: !605, line: 141)
!630 = !DISubprogram(name: "at_quick_exit", scope: !287, file: !287, line: 597, type: !626, flags: DIFlagPrototyped, spFlags: 0)
!631 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !632, file: !605, line: 144)
!632 = !DISubprogram(name: "atof", scope: !287, file: !287, line: 101, type: !237, flags: DIFlagPrototyped, spFlags: 0)
!633 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !634, file: !605, line: 145)
!634 = !DISubprogram(name: "atoi", scope: !287, file: !287, line: 104, type: !635, flags: DIFlagPrototyped, spFlags: 0)
!635 = !DISubroutineType(types: !636)
!636 = !{!98, !240}
!637 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !638, file: !605, line: 146)
!638 = !DISubprogram(name: "atol", scope: !287, file: !287, line: 107, type: !639, flags: DIFlagPrototyped, spFlags: 0)
!639 = !DISubroutineType(types: !640)
!640 = !{!196, !240}
!641 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !642, file: !605, line: 147)
!642 = !DISubprogram(name: "bsearch", scope: !287, file: !287, line: 817, type: !643, flags: DIFlagPrototyped, spFlags: 0)
!643 = !DISubroutineType(types: !644)
!644 = !{!620, !645, !645, !621, !621, !647}
!645 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !646, size: 64)
!646 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!647 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !287, line: 805, baseType: !648)
!648 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !649, size: 64)
!649 = !DISubroutineType(types: !650)
!650 = !{!98, !645, !645}
!651 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !652, file: !605, line: 148)
!652 = !DISubprogram(name: "calloc", scope: !287, file: !287, line: 541, type: !618, flags: DIFlagPrototyped, spFlags: 0)
!653 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !654, file: !605, line: 149)
!654 = !DISubprogram(name: "div", scope: !287, file: !287, line: 849, type: !655, flags: DIFlagPrototyped, spFlags: 0)
!655 = !DISubroutineType(types: !656)
!656 = !{!603, !98, !98}
!657 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !658, file: !605, line: 150)
!658 = !DISubprogram(name: "exit", scope: !287, file: !287, line: 614, type: !659, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!659 = !DISubroutineType(types: !660)
!660 = !{null, !98}
!661 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !662, file: !605, line: 151)
!662 = !DISubprogram(name: "free", scope: !287, file: !287, line: 563, type: !663, flags: DIFlagPrototyped, spFlags: 0)
!663 = !DISubroutineType(types: !664)
!664 = !{null, !620}
!665 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !666, file: !605, line: 152)
!666 = !DISubprogram(name: "getenv", scope: !287, file: !287, line: 631, type: !667, flags: DIFlagPrototyped, spFlags: 0)
!667 = !DISubroutineType(types: !668)
!668 = !{!669, !240}
!669 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !242, size: 64)
!670 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !671, file: !605, line: 153)
!671 = !DISubprogram(name: "labs", scope: !287, file: !287, line: 838, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!672 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !673, file: !605, line: 154)
!673 = !DISubprogram(name: "ldiv", scope: !287, file: !287, line: 851, type: !674, flags: DIFlagPrototyped, spFlags: 0)
!674 = !DISubroutineType(types: !675)
!675 = !{!607, !196, !196}
!676 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !677, file: !605, line: 155)
!677 = !DISubprogram(name: "malloc", scope: !287, file: !287, line: 539, type: !678, flags: DIFlagPrototyped, spFlags: 0)
!678 = !DISubroutineType(types: !679)
!679 = !{!620, !621}
!680 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !681, file: !605, line: 157)
!681 = !DISubprogram(name: "mblen", scope: !287, file: !287, line: 919, type: !682, flags: DIFlagPrototyped, spFlags: 0)
!682 = !DISubroutineType(types: !683)
!683 = !{!98, !240, !621}
!684 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !685, file: !605, line: 158)
!685 = !DISubprogram(name: "mbstowcs", scope: !287, file: !287, line: 930, type: !686, flags: DIFlagPrototyped, spFlags: 0)
!686 = !DISubroutineType(types: !687)
!687 = !{!621, !688, !691, !621}
!688 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !689)
!689 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !690, size: 64)
!690 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!691 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !240)
!692 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !693, file: !605, line: 159)
!693 = !DISubprogram(name: "mbtowc", scope: !287, file: !287, line: 922, type: !694, flags: DIFlagPrototyped, spFlags: 0)
!694 = !DISubroutineType(types: !695)
!695 = !{!98, !688, !691, !621}
!696 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !697, file: !605, line: 161)
!697 = !DISubprogram(name: "qsort", scope: !287, file: !287, line: 827, type: !698, flags: DIFlagPrototyped, spFlags: 0)
!698 = !DISubroutineType(types: !699)
!699 = !{null, !620, !621, !621, !647}
!700 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !701, file: !605, line: 164)
!701 = !DISubprogram(name: "quick_exit", scope: !287, file: !287, line: 620, type: !659, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!702 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !703, file: !605, line: 167)
!703 = !DISubprogram(name: "rand", scope: !287, file: !287, line: 453, type: !704, flags: DIFlagPrototyped, spFlags: 0)
!704 = !DISubroutineType(types: !705)
!705 = !{!98}
!706 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !707, file: !605, line: 168)
!707 = !DISubprogram(name: "realloc", scope: !287, file: !287, line: 549, type: !708, flags: DIFlagPrototyped, spFlags: 0)
!708 = !DISubroutineType(types: !709)
!709 = !{!620, !620, !621}
!710 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !711, file: !605, line: 169)
!711 = !DISubprogram(name: "srand", scope: !287, file: !287, line: 455, type: !712, flags: DIFlagPrototyped, spFlags: 0)
!712 = !DISubroutineType(types: !713)
!713 = !{null, !39}
!714 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !715, file: !605, line: 170)
!715 = !DISubprogram(name: "strtod", scope: !287, file: !287, line: 117, type: !716, flags: DIFlagPrototyped, spFlags: 0)
!716 = !DISubroutineType(types: !717)
!717 = !{!239, !691, !718}
!718 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !719)
!719 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !669, size: 64)
!720 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !721, file: !605, line: 171)
!721 = !DISubprogram(name: "strtol", scope: !287, file: !287, line: 176, type: !722, flags: DIFlagPrototyped, spFlags: 0)
!722 = !DISubroutineType(types: !723)
!723 = !{!196, !691, !718, !98}
!724 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !725, file: !605, line: 172)
!725 = !DISubprogram(name: "strtoul", scope: !287, file: !287, line: 180, type: !726, flags: DIFlagPrototyped, spFlags: 0)
!726 = !DISubroutineType(types: !727)
!727 = !{!623, !691, !718, !98}
!728 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !729, file: !605, line: 173)
!729 = !DISubprogram(name: "system", scope: !287, file: !287, line: 781, type: !635, flags: DIFlagPrototyped, spFlags: 0)
!730 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !731, file: !605, line: 175)
!731 = !DISubprogram(name: "wcstombs", scope: !287, file: !287, line: 933, type: !732, flags: DIFlagPrototyped, spFlags: 0)
!732 = !DISubroutineType(types: !733)
!733 = !{!621, !734, !735, !621}
!734 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !669)
!735 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !736)
!736 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !737, size: 64)
!737 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !690)
!738 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !739, file: !605, line: 176)
!739 = !DISubprogram(name: "wctomb", scope: !287, file: !287, line: 926, type: !740, flags: DIFlagPrototyped, spFlags: 0)
!740 = !DISubroutineType(types: !741)
!741 = !{!98, !669, !690}
!742 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !744, file: !605, line: 204)
!743 = !DINamespace(name: "__gnu_cxx", scope: null)
!744 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !287, line: 80, baseType: !745)
!745 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !287, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !746, identifier: "_ZTS7lldiv_t")
!746 = !{!747, !748}
!747 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !745, file: !287, line: 78, baseType: !207, size: 64)
!748 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !745, file: !287, line: 79, baseType: !207, size: 64, offset: 64)
!749 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !750, file: !605, line: 210)
!750 = !DISubprogram(name: "_Exit", scope: !287, file: !287, line: 626, type: !659, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!751 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !752, file: !605, line: 214)
!752 = !DISubprogram(name: "llabs", scope: !287, file: !287, line: 841, type: !205, flags: DIFlagPrototyped, spFlags: 0)
!753 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !754, file: !605, line: 220)
!754 = !DISubprogram(name: "lldiv", scope: !287, file: !287, line: 855, type: !755, flags: DIFlagPrototyped, spFlags: 0)
!755 = !DISubroutineType(types: !756)
!756 = !{!744, !207, !207}
!757 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !758, file: !605, line: 231)
!758 = !DISubprogram(name: "atoll", scope: !287, file: !287, line: 112, type: !759, flags: DIFlagPrototyped, spFlags: 0)
!759 = !DISubroutineType(types: !760)
!760 = !{!207, !240}
!761 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !762, file: !605, line: 232)
!762 = !DISubprogram(name: "strtoll", scope: !287, file: !287, line: 200, type: !763, flags: DIFlagPrototyped, spFlags: 0)
!763 = !DISubroutineType(types: !764)
!764 = !{!207, !691, !718, !98}
!765 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !766, file: !605, line: 233)
!766 = !DISubprogram(name: "strtoull", scope: !287, file: !287, line: 205, type: !767, flags: DIFlagPrototyped, spFlags: 0)
!767 = !DISubroutineType(types: !768)
!768 = !{!9, !691, !718, !98}
!769 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !770, file: !605, line: 235)
!770 = !DISubprogram(name: "strtof", scope: !287, file: !287, line: 123, type: !771, flags: DIFlagPrototyped, spFlags: 0)
!771 = !DISubroutineType(types: !772)
!772 = !{!103, !691, !718}
!773 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !743, entity: !774, file: !605, line: 236)
!774 = !DISubprogram(name: "strtold", scope: !287, file: !287, line: 126, type: !775, flags: DIFlagPrototyped, spFlags: 0)
!775 = !DISubroutineType(types: !776)
!776 = !{!359, !691, !718}
!777 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !744, file: !605, line: 244)
!778 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !750, file: !605, line: 246)
!779 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !752, file: !605, line: 248)
!780 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !781, file: !605, line: 249)
!781 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !743, file: !605, line: 217, type: !755, flags: DIFlagPrototyped, spFlags: 0)
!782 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !754, file: !605, line: 250)
!783 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !758, file: !605, line: 252)
!784 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !770, file: !605, line: 253)
!785 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !762, file: !605, line: 254)
!786 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !766, file: !605, line: 255)
!787 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !774, file: !605, line: 256)
!788 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !613, file: !789, line: 38)
!789 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/stdlib.h", directory: "")
!790 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !625, file: !789, line: 39)
!791 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !658, file: !789, line: 40)
!792 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !630, file: !789, line: 43)
!793 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !701, file: !789, line: 46)
!794 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !750, file: !789, line: 49)
!795 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !603, file: !789, line: 54)
!796 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !607, file: !789, line: 55)
!797 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !798, file: !789, line: 57)
!798 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !93, file: !288, line: 137, type: !799, flags: DIFlagPrototyped, spFlags: 0)
!799 = !DISubroutineType(types: !800)
!800 = !{!801, !801}
!801 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!802 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !632, file: !789, line: 58)
!803 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !634, file: !789, line: 59)
!804 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !638, file: !789, line: 60)
!805 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !642, file: !789, line: 61)
!806 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !652, file: !789, line: 62)
!807 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !781, file: !789, line: 63)
!808 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !662, file: !789, line: 64)
!809 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !666, file: !789, line: 65)
!810 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !671, file: !789, line: 66)
!811 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !673, file: !789, line: 67)
!812 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !677, file: !789, line: 68)
!813 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !681, file: !789, line: 70)
!814 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !685, file: !789, line: 71)
!815 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !693, file: !789, line: 72)
!816 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !697, file: !789, line: 74)
!817 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !703, file: !789, line: 75)
!818 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !707, file: !789, line: 76)
!819 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !711, file: !789, line: 77)
!820 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !715, file: !789, line: 78)
!821 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !721, file: !789, line: 79)
!822 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !725, file: !789, line: 80)
!823 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !729, file: !789, line: 81)
!824 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !731, file: !789, line: 83)
!825 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !739, file: !789, line: 84)
!826 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !827, file: !829, line: 443)
!827 = !DISubprogram(name: "acosf", linkageName: "_ZL5acosff", scope: !828, file: !828, line: 63, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!828 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_math.h", directory: "")
!829 = !DIFile(filename: "/storage/users/sislam3/opt/llvm-22/lib/clang/22/include/__clang_cuda_cmath.h", directory: "")
!830 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !831, file: !829, line: 444)
!831 = !DISubprogram(name: "acoshf", linkageName: "_ZL6acoshff", scope: !828, file: !828, line: 65, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!832 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !833, file: !829, line: 445)
!833 = !DISubprogram(name: "asinf", linkageName: "_ZL5asinff", scope: !828, file: !828, line: 67, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!834 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !835, file: !829, line: 446)
!835 = !DISubprogram(name: "asinhf", linkageName: "_ZL6asinhff", scope: !828, file: !828, line: 69, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!836 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !837, file: !829, line: 447)
!837 = !DISubprogram(name: "atan2f", linkageName: "_ZL6atan2fff", scope: !828, file: !828, line: 72, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!838 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !839, file: !829, line: 448)
!839 = !DISubprogram(name: "atanf", linkageName: "_ZL5atanff", scope: !828, file: !828, line: 73, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!840 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !841, file: !829, line: 449)
!841 = !DISubprogram(name: "atanhf", linkageName: "_ZL6atanhff", scope: !828, file: !828, line: 75, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!842 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !843, file: !829, line: 450)
!843 = !DISubprogram(name: "cbrtf", linkageName: "_ZL5cbrtff", scope: !828, file: !828, line: 77, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!844 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !845, file: !829, line: 451)
!845 = !DISubprogram(name: "ceilf", linkageName: "_ZL5ceilff", scope: !828, file: !828, line: 79, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!846 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !847, file: !829, line: 452)
!847 = !DISubprogram(name: "copysignf", linkageName: "_ZL9copysignfff", scope: !828, file: !828, line: 83, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!848 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !849, file: !829, line: 453)
!849 = !DISubprogram(name: "cosf", linkageName: "_ZL4cosff", scope: !828, file: !828, line: 87, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!850 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !851, file: !829, line: 454)
!851 = !DISubprogram(name: "coshf", linkageName: "_ZL5coshff", scope: !828, file: !828, line: 91, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!852 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !853, file: !829, line: 455)
!853 = !DISubprogram(name: "erfcf", linkageName: "_ZL5erfcff", scope: !828, file: !828, line: 100, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!854 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !855, file: !829, line: 456)
!855 = !DISubprogram(name: "erff", linkageName: "_ZL4erfff", scope: !828, file: !828, line: 105, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!856 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !857, file: !829, line: 457)
!857 = !DISubprogram(name: "exp2f", linkageName: "_ZL5exp2ff", scope: !828, file: !828, line: 112, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!858 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !859, file: !829, line: 458)
!859 = distinct !DISubprogram(name: "expf", linkageName: "_ZL4expff", scope: !828, file: !828, line: 113, type: !101, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!860 = !{}
!861 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !862, file: !829, line: 459)
!862 = !DISubprogram(name: "expm1f", linkageName: "_ZL6expm1ff", scope: !828, file: !828, line: 115, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!863 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !864, file: !829, line: 460)
!864 = distinct !DISubprogram(name: "fabsf", linkageName: "_ZL5fabsff", scope: !828, file: !828, line: 116, type: !101, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!865 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !866, file: !829, line: 461)
!866 = !DISubprogram(name: "fdimf", linkageName: "_ZL5fdimfff", scope: !828, file: !828, line: 118, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!867 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !868, file: !829, line: 462)
!868 = !DISubprogram(name: "floorf", linkageName: "_ZL6floorff", scope: !828, file: !828, line: 128, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!869 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !870, file: !829, line: 463)
!870 = !DISubprogram(name: "fmaf", linkageName: "_ZL4fmaffff", scope: !828, file: !828, line: 132, type: !146, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!871 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !872, file: !829, line: 464)
!872 = !DISubprogram(name: "fmaxf", linkageName: "_ZL5fmaxfff", scope: !828, file: !828, line: 136, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!873 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !874, file: !829, line: 465)
!874 = !DISubprogram(name: "fminf", linkageName: "_ZL5fminfff", scope: !828, file: !828, line: 138, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!875 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !876, file: !829, line: 466)
!876 = !DISubprogram(name: "fmodf", linkageName: "_ZL5fmodfff", scope: !828, file: !828, line: 140, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!877 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !878, file: !829, line: 467)
!878 = !DISubprogram(name: "frexpf", linkageName: "_ZL6frexpffPi", scope: !828, file: !828, line: 142, type: !160, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!879 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !880, file: !829, line: 468)
!880 = !DISubprogram(name: "hypotf", linkageName: "_ZL6hypotfff", scope: !828, file: !828, line: 144, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!881 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !882, file: !829, line: 469)
!882 = !DISubprogram(name: "ilogbf", linkageName: "_ZL6ilogbff", scope: !828, file: !828, line: 146, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!883 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !884, file: !829, line: 470)
!884 = !DISubprogram(name: "ldexpf", linkageName: "_ZL6ldexpffi", scope: !828, file: !828, line: 159, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!885 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !886, file: !829, line: 471)
!886 = !DISubprogram(name: "lgammaf", linkageName: "_ZL7lgammaff", scope: !828, file: !828, line: 161, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!887 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !888, file: !829, line: 472)
!888 = !DISubprogram(name: "llrintf", linkageName: "_ZL7llrintff", scope: !828, file: !828, line: 170, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!889 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !890, file: !829, line: 473)
!890 = !DISubprogram(name: "llroundf", linkageName: "_ZL8llroundff", scope: !828, file: !828, line: 172, type: !210, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!891 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !892, file: !829, line: 474)
!892 = !DISubprogram(name: "log10f", linkageName: "_ZL6log10ff", scope: !828, file: !828, line: 177, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!893 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !894, file: !829, line: 475)
!894 = !DISubprogram(name: "log1pf", linkageName: "_ZL6log1pff", scope: !828, file: !828, line: 179, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!895 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !896, file: !829, line: 476)
!896 = !DISubprogram(name: "log2f", linkageName: "_ZL5log2ff", scope: !828, file: !828, line: 181, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!897 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !898, file: !829, line: 477)
!898 = !DISubprogram(name: "logbf", linkageName: "_ZL5logbff", scope: !828, file: !828, line: 185, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!899 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !900, file: !829, line: 478)
!900 = distinct !DISubprogram(name: "logf", linkageName: "_ZL4logff", scope: !828, file: !828, line: 186, type: !101, scopeLine: 186, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!901 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !902, file: !829, line: 479)
!902 = !DISubprogram(name: "lrintf", linkageName: "_ZL6lrintff", scope: !828, file: !828, line: 191, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!903 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !904, file: !829, line: 480)
!904 = !DISubprogram(name: "lroundf", linkageName: "_ZL7lroundff", scope: !828, file: !828, line: 193, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!905 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !906, file: !829, line: 481)
!906 = !DISubprogram(name: "modff", linkageName: "_ZL5modfffPf", scope: !828, file: !828, line: 203, type: !232, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!907 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !908, file: !829, line: 482)
!908 = !DISubprogram(name: "nearbyintf", linkageName: "_ZL10nearbyintff", scope: !828, file: !828, line: 205, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!909 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !910, file: !829, line: 483)
!910 = !DISubprogram(name: "nextafterf", linkageName: "_ZL10nextafterfff", scope: !828, file: !828, line: 209, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!911 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !912, file: !829, line: 484)
!912 = distinct !DISubprogram(name: "powf", linkageName: "_ZL4powfff", scope: !828, file: !828, line: 235, type: !114, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!913 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !914, file: !829, line: 485)
!914 = !DISubprogram(name: "remainderf", linkageName: "_ZL10remainderfff", scope: !828, file: !828, line: 243, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!915 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !916, file: !829, line: 486)
!916 = !DISubprogram(name: "remquof", linkageName: "_ZL7remquofffPi", scope: !828, file: !828, line: 249, type: !257, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!917 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !918, file: !829, line: 487)
!918 = !DISubprogram(name: "rintf", linkageName: "_ZL5rintff", scope: !828, file: !828, line: 260, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!919 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !920, file: !829, line: 488)
!920 = !DISubprogram(name: "roundf", linkageName: "_ZL6roundff", scope: !828, file: !828, line: 174, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!921 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !922, file: !829, line: 489)
!922 = !DISubprogram(name: "scalblnf", linkageName: "_ZL8scalblnffl", scope: !828, file: !828, line: 290, type: !265, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!923 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !924, file: !829, line: 490)
!924 = !DISubprogram(name: "scalbnf", linkageName: "_ZL7scalbnffi", scope: !828, file: !828, line: 282, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!925 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !926, file: !829, line: 491)
!926 = !DISubprogram(name: "sinf", linkageName: "_ZL4sinff", scope: !828, file: !828, line: 310, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!927 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !928, file: !829, line: 492)
!928 = !DISubprogram(name: "sinhf", linkageName: "_ZL5sinhff", scope: !828, file: !828, line: 314, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!929 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !930, file: !829, line: 493)
!930 = distinct !DISubprogram(name: "sqrtf", linkageName: "_ZL5sqrtff", scope: !828, file: !828, line: 318, type: !101, scopeLine: 318, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !860)
!931 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !932, file: !829, line: 494)
!932 = !DISubprogram(name: "tanf", linkageName: "_ZL4tanff", scope: !828, file: !828, line: 320, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!933 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !934, file: !829, line: 495)
!934 = !DISubprogram(name: "tanhf", linkageName: "_ZL5tanhff", scope: !828, file: !828, line: 322, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!935 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !936, file: !829, line: 496)
!936 = !DISubprogram(name: "tgammaf", linkageName: "_ZL7tgammaff", scope: !828, file: !828, line: 324, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!937 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !938, file: !829, line: 497)
!938 = !DISubprogram(name: "truncf", linkageName: "_ZL6truncff", scope: !828, file: !828, line: 326, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!939 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !3, file: !4, line: 181)
!940 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !28, file: !4, line: 182)
!941 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !942, file: !4, line: 208)
!942 = !DISubprogram(name: "is_exactly", linkageName: "_ZN2nv6target6detail10is_exactlyENS1_11sm_selectorE", scope: !5, file: !4, line: 153, type: !943, flags: DIFlagPrototyped, spFlags: 0)
!943 = !DISubroutineType(types: !944)
!944 = !{!28, !3}
!945 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !6, entity: !946, file: !4, line: 209)
!946 = !DISubprogram(name: "provides", linkageName: "_ZN2nv6target6detail8providesENS1_11sm_selectorE", scope: !5, file: !4, line: 158, type: !943, flags: DIFlagPrototyped, spFlags: 0)
!947 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !798, file: !948, line: 38)
!948 = !DIFile(filename: "/opt/rh/gcc-toolset-13/root/usr/lib/gcc/x86_64-redhat-linux/13/../../../../include/c++/13/math.h", directory: "")
!949 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !950, file: !948, line: 54)
!950 = !DISubprogram(name: "modf", linkageName: "_ZSt4modfePe", scope: !93, file: !294, line: 364, type: !951, flags: DIFlagPrototyped, spFlags: 0)
!951 = !DISubroutineType(types: !952)
!952 = !{!359, !359, !953}
!953 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !359, size: 64)
!954 = !{!"clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)"}
!955 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!956 = !{i32 2, i32 0}
!957 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 8]}
!958 = !{i32 7, !"Dwarf Version", i32 2}
!959 = !{i32 2, !"Debug Info Version", i32 3}
!960 = !{i32 1, !"wchar_size", i32 4}
!961 = !{i32 4, !"nvvm-reflect-ftz", i32 0}
!962 = !{i32 7, !"frame-pointer", i32 2}
!963 = distinct !DISubprogram(name: "is_subnormal", linkageName: "_Z12is_subnormalf", scope: !1, file: !1, line: 6, type: !169, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !860)
!964 = !DILocalVariable(name: "x", arg: 1, scope: !963, file: !1, line: 6, type: !103)
!965 = !DILocation(line: 6, column: 36, scope: !963)
!966 = !DILocation(line: 7, column: 13, scope: !963)
!967 = !DILocation(line: 7, column: 15, scope: !963)
!968 = !DILocation(line: 7, column: 24, scope: !963)
!969 = !DILocation(line: 7, column: 34, scope: !963)
!970 = !DILocalVariable(name: "__a", arg: 1, scope: !864, file: !828, line: 116, type: !103)
!971 = !DILocation(line: 116, column: 30, scope: !864, inlinedAt: !972)
!972 = distinct !DILocation(line: 7, column: 28, scope: !963)
!973 = !DILocation(line: 116, column: 55, scope: !864, inlinedAt: !972)
!974 = !DILocation(line: 116, column: 44, scope: !864, inlinedAt: !972)
!975 = !DILocation(line: 7, column: 37, scope: !963)
!976 = !DILocation(line: 0, scope: !963)
!977 = !DILocation(line: 7, column: 5, scope: !963)
!978 = distinct !DISubprogram(name: "testUnderflow_Operations", linkageName: "_Z24testUnderflow_OperationsPfPi", scope: !1, file: !1, line: 10, type: !979, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !860)
!979 = !DISubroutineType(types: !980)
!980 = !{null, !234, !162}
!981 = !DILocalVariable(name: "result", arg: 1, scope: !978, file: !1, line: 10, type: !234)
!982 = !DILocation(line: 10, column: 49, scope: !978)
!983 = !DILocalVariable(name: "is_denorm", arg: 2, scope: !978, file: !1, line: 10, type: !162)
!984 = !DILocation(line: 10, column: 62, scope: !978)
!985 = !DILocalVariable(name: "idx", scope: !978, file: !1, line: 11, type: !98)
!986 = !DILocation(line: 11, column: 9, scope: !978)
!987 = !DILocation(line: 53, column: 27, scope: !988, inlinedAt: !989)
!988 = distinct !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !60, file: !61, line: 53, type: !64, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !63)
!989 = distinct !DILocation(line: 11, column: 15, scope: !978)
!990 = !DILocalVariable(name: "tiny", scope: !978, file: !1, line: 13, type: !103)
!991 = !DILocation(line: 13, column: 11, scope: !978)
!992 = !DILocation(line: 17, column: 9, scope: !993)
!993 = distinct !DILexicalBlock(scope: !978, file: !1, line: 17, column: 9)
!994 = !DILocation(line: 17, column: 13, scope: !993)
!995 = !DILocation(line: 19, column: 21, scope: !996)
!996 = distinct !DILexicalBlock(scope: !993, file: !1, line: 17, column: 19)
!997 = !DILocation(line: 19, column: 26, scope: !996)
!998 = !DILocation(line: 19, column: 9, scope: !996)
!999 = !DILocation(line: 19, column: 19, scope: !996)
!1000 = !DILocation(line: 20, column: 37, scope: !996)
!1001 = !DILocation(line: 20, column: 24, scope: !996)
!1002 = !DILocation(line: 20, column: 9, scope: !996)
!1003 = !DILocation(line: 20, column: 22, scope: !996)
!1004 = !DILocation(line: 21, column: 5, scope: !996)
!1005 = !DILocation(line: 23, column: 9, scope: !1006)
!1006 = distinct !DILexicalBlock(scope: !978, file: !1, line: 23, column: 9)
!1007 = !DILocation(line: 23, column: 13, scope: !1006)
!1008 = !DILocation(line: 25, column: 21, scope: !1009)
!1009 = distinct !DILexicalBlock(scope: !1006, file: !1, line: 23, column: 19)
!1010 = !DILocation(line: 25, column: 26, scope: !1009)
!1011 = !DILocation(line: 25, column: 9, scope: !1009)
!1012 = !DILocation(line: 25, column: 19, scope: !1009)
!1013 = !DILocation(line: 26, column: 37, scope: !1009)
!1014 = !DILocation(line: 26, column: 24, scope: !1009)
!1015 = !DILocation(line: 26, column: 9, scope: !1009)
!1016 = !DILocation(line: 26, column: 22, scope: !1009)
!1017 = !DILocation(line: 27, column: 5, scope: !1009)
!1018 = !DILocation(line: 29, column: 9, scope: !1019)
!1019 = distinct !DILexicalBlock(scope: !978, file: !1, line: 29, column: 9)
!1020 = !DILocation(line: 29, column: 13, scope: !1019)
!1021 = !DILocalVariable(name: "a", scope: !1022, file: !1, line: 31, type: !103)
!1022 = distinct !DILexicalBlock(scope: !1019, file: !1, line: 29, column: 19)
!1023 = !DILocation(line: 31, column: 15, scope: !1022)
!1024 = !DILocalVariable(name: "b", scope: !1022, file: !1, line: 32, type: !103)
!1025 = !DILocation(line: 32, column: 15, scope: !1022)
!1026 = !DILocation(line: 33, column: 21, scope: !1022)
!1027 = !DILocation(line: 33, column: 25, scope: !1022)
!1028 = !DILocation(line: 33, column: 23, scope: !1022)
!1029 = !DILocation(line: 33, column: 9, scope: !1022)
!1030 = !DILocation(line: 33, column: 19, scope: !1022)
!1031 = !DILocation(line: 34, column: 37, scope: !1022)
!1032 = !DILocation(line: 34, column: 24, scope: !1022)
!1033 = !DILocation(line: 34, column: 9, scope: !1022)
!1034 = !DILocation(line: 34, column: 22, scope: !1022)
!1035 = !DILocation(line: 35, column: 5, scope: !1022)
!1036 = !DILocation(line: 37, column: 9, scope: !1037)
!1037 = distinct !DILexicalBlock(scope: !978, file: !1, line: 37, column: 9)
!1038 = !DILocation(line: 37, column: 13, scope: !1037)
!1039 = !DILocalVariable(name: "denorm", scope: !1040, file: !1, line: 39, type: !103)
!1040 = distinct !DILexicalBlock(scope: !1037, file: !1, line: 37, column: 19)
!1041 = !DILocation(line: 39, column: 15, scope: !1040)
!1042 = !DILocation(line: 40, column: 21, scope: !1040)
!1043 = !DILocation(line: 40, column: 30, scope: !1040)
!1044 = !DILocation(line: 40, column: 28, scope: !1040)
!1045 = !DILocation(line: 40, column: 9, scope: !1040)
!1046 = !DILocation(line: 40, column: 19, scope: !1040)
!1047 = !DILocation(line: 41, column: 37, scope: !1040)
!1048 = !DILocation(line: 41, column: 24, scope: !1040)
!1049 = !DILocation(line: 41, column: 9, scope: !1040)
!1050 = !DILocation(line: 41, column: 22, scope: !1040)
!1051 = !DILocation(line: 42, column: 5, scope: !1040)
!1052 = !DILocation(line: 44, column: 9, scope: !1053)
!1053 = distinct !DILexicalBlock(scope: !978, file: !1, line: 44, column: 9)
!1054 = !DILocation(line: 44, column: 13, scope: !1053)
!1055 = !DILocation(line: 46, column: 27, scope: !1056)
!1056 = distinct !DILexicalBlock(scope: !1053, file: !1, line: 44, column: 19)
!1057 = !DILocalVariable(name: "__a", arg: 1, scope: !930, file: !828, line: 318, type: !103)
!1058 = !DILocation(line: 318, column: 30, scope: !930, inlinedAt: !1059)
!1059 = distinct !DILocation(line: 46, column: 21, scope: !1056)
!1060 = !DILocation(line: 318, column: 55, scope: !930, inlinedAt: !1059)
!1061 = !DILocation(line: 318, column: 44, scope: !930, inlinedAt: !1059)
!1062 = !DILocation(line: 46, column: 9, scope: !1056)
!1063 = !DILocation(line: 46, column: 19, scope: !1056)
!1064 = !DILocation(line: 47, column: 37, scope: !1056)
!1065 = !DILocation(line: 47, column: 24, scope: !1056)
!1066 = !DILocation(line: 47, column: 9, scope: !1056)
!1067 = !DILocation(line: 47, column: 22, scope: !1056)
!1068 = !DILocation(line: 48, column: 5, scope: !1056)
!1069 = !DILocation(line: 50, column: 9, scope: !1070)
!1070 = distinct !DILexicalBlock(scope: !978, file: !1, line: 50, column: 9)
!1071 = !DILocation(line: 50, column: 13, scope: !1070)
!1072 = !DILocalVariable(name: "__a", arg: 1, scope: !859, file: !828, line: 113, type: !103)
!1073 = !DILocation(line: 113, column: 29, scope: !859, inlinedAt: !1074)
!1074 = distinct !DILocation(line: 52, column: 21, scope: !1075)
!1075 = distinct !DILexicalBlock(scope: !1070, file: !1, line: 50, column: 19)
!1076 = !DILocation(line: 113, column: 53, scope: !859, inlinedAt: !1074)
!1077 = !DILocation(line: 113, column: 43, scope: !859, inlinedAt: !1074)
!1078 = !DILocation(line: 52, column: 9, scope: !1075)
!1079 = !DILocation(line: 52, column: 19, scope: !1075)
!1080 = !DILocation(line: 53, column: 37, scope: !1075)
!1081 = !DILocation(line: 53, column: 24, scope: !1075)
!1082 = !DILocation(line: 53, column: 9, scope: !1075)
!1083 = !DILocation(line: 53, column: 22, scope: !1075)
!1084 = !DILocation(line: 54, column: 5, scope: !1075)
!1085 = !DILocation(line: 56, column: 9, scope: !1086)
!1086 = distinct !DILexicalBlock(scope: !978, file: !1, line: 56, column: 9)
!1087 = !DILocation(line: 56, column: 13, scope: !1086)
!1088 = !DILocalVariable(name: "__a", arg: 1, scope: !912, file: !828, line: 235, type: !103)
!1089 = !DILocation(line: 235, column: 29, scope: !912, inlinedAt: !1090)
!1090 = distinct !DILocation(line: 58, column: 21, scope: !1091)
!1091 = distinct !DILexicalBlock(scope: !1086, file: !1, line: 56, column: 19)
!1092 = !DILocalVariable(name: "__b", arg: 2, scope: !912, file: !828, line: 235, type: !103)
!1093 = !DILocation(line: 235, column: 40, scope: !912, inlinedAt: !1090)
!1094 = !DILocation(line: 235, column: 64, scope: !912, inlinedAt: !1090)
!1095 = !DILocation(line: 235, column: 69, scope: !912, inlinedAt: !1090)
!1096 = !DILocation(line: 235, column: 54, scope: !912, inlinedAt: !1090)
!1097 = !{i32 21684}
!1098 = !DILocation(line: 58, column: 9, scope: !1091)
!1099 = !DILocation(line: 58, column: 19, scope: !1091)
!1100 = !DILocation(line: 59, column: 37, scope: !1091)
!1101 = !DILocation(line: 59, column: 24, scope: !1091)
!1102 = !DILocation(line: 59, column: 9, scope: !1091)
!1103 = !DILocation(line: 59, column: 22, scope: !1091)
!1104 = !DILocation(line: 60, column: 5, scope: !1091)
!1105 = !DILocation(line: 62, column: 9, scope: !1106)
!1106 = distinct !DILexicalBlock(scope: !978, file: !1, line: 62, column: 9)
!1107 = !DILocation(line: 62, column: 13, scope: !1106)
!1108 = !DILocalVariable(name: "__a", arg: 1, scope: !900, file: !828, line: 186, type: !103)
!1109 = !DILocation(line: 186, column: 29, scope: !900, inlinedAt: !1110)
!1110 = distinct !DILocation(line: 64, column: 21, scope: !1111)
!1111 = distinct !DILexicalBlock(scope: !1106, file: !1, line: 62, column: 19)
!1112 = !DILocation(line: 187, column: 52, scope: !900, inlinedAt: !1110)
!1113 = !DILocation(line: 187, column: 41, scope: !900, inlinedAt: !1110)
!1114 = !DILocation(line: 64, column: 9, scope: !1111)
!1115 = !DILocation(line: 64, column: 19, scope: !1111)
!1116 = !DILocation(line: 65, column: 37, scope: !1111)
!1117 = !DILocation(line: 65, column: 24, scope: !1111)
!1118 = !DILocation(line: 65, column: 9, scope: !1111)
!1119 = !DILocation(line: 65, column: 22, scope: !1111)
!1120 = !DILocation(line: 66, column: 5, scope: !1111)
!1121 = !DILocation(line: 67, column: 1, scope: !978)
