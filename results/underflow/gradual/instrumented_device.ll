; ModuleID = '/home/users/sislam3/SBAC-PAD/results/underflow/gradual/instrumented_device.bc'
source_filename = "llvm-link"
target datalayout = "e-p6:32:32-i64:64-i128:128-i256:256-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

@fp_counters = addrspace(1) global [6 x i64] zeroinitializer, align 8

; Function Attrs: convergent noinline nounwind optnone
define dso_local noundef zeroext i1 @_Z12is_subnormalf(float noundef %x) #0 !dbg !956 {
entry:
  %__a.addr.i = alloca float, align 4
  %x.addr = alloca float, align 4
  store float %x, ptr %x.addr, align 4
    #dbg_declare(ptr %x.addr, !957, !DIExpression(), !958)
  %0 = load float, ptr %x.addr, align 4, !dbg !959
  %cmp = fcmp contract une float %0, 0.000000e+00, !dbg !960
  br i1 %cmp, label %land.rhs, label %land.end, !dbg !961

land.rhs:                                         ; preds = %entry
  %1 = load float, ptr %x.addr, align 4, !dbg !962
  store float %1, ptr %__a.addr.i, align 4
    #dbg_declare(ptr %__a.addr.i, !963, !DIExpression(), !964)
  %2 = load float, ptr %__a.addr.i, align 4, !dbg !966
  %3 = call float @llvm.nvvm.fabs.f32(float %2), !dbg !967
  %cmp1 = fcmp contract olt float %3, 0x3810000000000000, !dbg !968
  br label %land.end

land.end:                                         ; preds = %land.rhs, %entry
  %4 = phi i1 [ false, %entry ], [ %cmp1, %land.rhs ], !dbg !969
  ret i1 %4, !dbg !970
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.nvvm.fabs.f32(float) #1

; Function Attrs: convergent mustprogress noinline norecurse nounwind optnone
define dso_local ptx_kernel void @_Z20testGradualUnderflowPfPi(ptr noundef %result, ptr noundef %status) #2 !dbg !971 {
entry:
  %result.addr = alloca ptr, align 8
  %status.addr = alloca ptr, align 8
  %idx = alloca i32, align 4
  %base = alloca float, align 4
  store ptr %result, ptr %result.addr, align 8
    #dbg_declare(ptr %result.addr, !974, !DIExpression(), !975)
  store ptr %status, ptr %status.addr, align 8
    #dbg_declare(ptr %status.addr, !976, !DIExpression(), !977)
    #dbg_declare(ptr %idx, !978, !DIExpression(), !979)
  %0 = call noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !980
  store i32 %0, ptr %idx, align 4, !dbg !979
    #dbg_declare(ptr %base, !983, !DIExpression(), !984)
  store float 0x3810000000000000, ptr %base, align 4, !dbg !984
  %1 = load i32, ptr %idx, align 4, !dbg !985
  %cmp = icmp eq i32 %1, 0, !dbg !987
  br i1 %cmp, label %if.then, label %if.end, !dbg !987

if.then:                                          ; preds = %entry
  %2 = load float, ptr %base, align 4, !dbg !988
  %3 = load ptr, ptr %result.addr, align 8, !dbg !990
  %arrayidx = getelementptr inbounds float, ptr %3, i64 0, !dbg !990
  store float %2, ptr %arrayidx, align 4, !dbg !991
  %4 = load ptr, ptr %result.addr, align 8, !dbg !992
  %arrayidx1 = getelementptr inbounds float, ptr %4, i64 0, !dbg !992
  %5 = load float, ptr %arrayidx1, align 4, !dbg !992
  %call2 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %5) #3, !dbg !993
  %6 = zext i1 %call2 to i64, !dbg !993
  %cond = select i1 %call2, i32 2, i32 1, !dbg !993
  %7 = load ptr, ptr %status.addr, align 8, !dbg !994
  %arrayidx3 = getelementptr inbounds i32, ptr %7, i64 0, !dbg !994
  store i32 %cond, ptr %arrayidx3, align 4, !dbg !995
  br label %if.end, !dbg !996

if.end:                                           ; preds = %if.then, %entry
  %8 = load i32, ptr %idx, align 4, !dbg !997
  %cmp4 = icmp eq i32 %8, 1, !dbg !999
  br i1 %cmp4, label %if.then5, label %if.end11, !dbg !999

if.then5:                                         ; preds = %if.end
  %9 = load float, ptr %base, align 4, !dbg !1000
  %10 = bitcast float %9 to i32, !dbg !1002
  %11 = bitcast float %9 to i32, !dbg !1002
  %12 = and i32 %11, 2139095040, !dbg !1002
  %13 = icmp eq i32 %12, 2139095040, !dbg !1002
  %14 = and i32 %11, 8388607, !dbg !1002
  %15 = icmp ne i32 %14, 0, !dbg !1002
  %is_nan = and i1 %13, %15, !dbg !1002
  %16 = and i32 %10, 4194304, !dbg !1002
  %17 = icmp eq i32 %16, 0, !dbg !1002
  %is_snan = and i1 %is_nan, %17, !dbg !1002
  %18 = or i1 %is_snan, false, !dbg !1002
  %19 = bitcast float %9 to i32, !dbg !1002
  %20 = and i32 %19, 2147483647, !dbg !1002
  %is_zero = icmp eq i32 %20, 0, !dbg !1002
  %21 = and i1 %is_zero, false, !dbg !1002
  %22 = bitcast float %9 to i32, !dbg !1002
  %23 = and i32 %22, 2139095040, !dbg !1002
  %24 = icmp eq i32 %23, 2139095040, !dbg !1002
  %25 = and i32 %22, 8388607, !dbg !1002
  %26 = icmp eq i32 %25, 0, !dbg !1002
  %is_inf = and i1 %24, %26, !dbg !1002
  %27 = and i1 %is_inf, false, !dbg !1002
  %28 = or i1 %21, %27, !dbg !1002
  %29 = or i1 %18, %28, !dbg !1002
  br i1 %29, label %30, label %32, !dbg !1002

30:                                               ; preds = %if.then5
  %31 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1002
  br label %32, !dbg !1002

32:                                               ; preds = %if.then5, %30
  %33 = bitcast float %9 to i32, !dbg !1002
  %34 = and i32 %33, 2139095040, !dbg !1002
  %is_finite = icmp ne i32 %34, 2139095040, !dbg !1002
  %35 = bitcast float %9 to i32, !dbg !1002
  %36 = and i32 %35, 2147483647, !dbg !1002
  %is_zero1 = icmp eq i32 %36, 0, !dbg !1002
  %37 = xor i1 %is_zero1, true, !dbg !1002
  %38 = and i1 %is_finite, %37, !dbg !1002
  %divzero_cond = and i1 false, %38, !dbg !1002
  br i1 %divzero_cond, label %39, label %41, !dbg !1002

39:                                               ; preds = %32
  %40 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1002
  br label %41, !dbg !1002

41:                                               ; preds = %32, %39
  %div = fdiv contract float %9, 2.000000e+00, !dbg !1002
  %42 = bitcast float %9 to i32, !dbg !1003
  %43 = and i32 %42, 2139095040, !dbg !1003
  %is_finite2 = icmp ne i32 %43, 2139095040, !dbg !1003
  %44 = and i1 true, %is_finite2, !dbg !1003
  %45 = and i1 %44, true, !dbg !1003
  %overflow_denom_nonzero = and i1 %45, true, !dbg !1003
  %46 = bitcast float %div to i32, !dbg !1003
  %47 = and i32 %46, 2139095040, !dbg !1003
  %48 = icmp eq i32 %47, 2139095040, !dbg !1003
  %49 = and i32 %46, 8388607, !dbg !1003
  %50 = icmp eq i32 %49, 0, !dbg !1003
  %is_inf3 = and i1 %48, %50, !dbg !1003
  %51 = bitcast float %div to i32, !dbg !1003
  %52 = and i32 %51, 2147483647, !dbg !1003
  %is_maxfinite = icmp eq i32 %52, 2139095039, !dbg !1003
  %53 = bitcast float %div to i32, !dbg !1003
  %54 = and i32 %53, -2147483648, !dbg !1003
  %55 = icmp eq i32 %54, 0, !dbg !1003
  %56 = icmp ne i32 %54, 0, !dbg !1003
  %is_pos_inf = and i1 %is_inf3, %55, !dbg !1003
  %is_neg_inf = and i1 %is_inf3, %56, !dbg !1003
  %is_pos_max = and i1 %is_maxfinite, %55, !dbg !1003
  %is_neg_max = and i1 %is_maxfinite, %56, !dbg !1003
  %overflow_cond = and i1 %overflow_denom_nonzero, %is_inf3, !dbg !1003
  br i1 %overflow_cond, label %57, label %59, !dbg !1003

57:                                               ; preds = %41
  %58 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1003
  br label %59, !dbg !1003

59:                                               ; preds = %41, %57
  %60 = bitcast float %9 to i32, !dbg !1003
  %61 = and i32 %60, 2139095040, !dbg !1003
  %62 = icmp eq i32 %61, 0, !dbg !1003
  %63 = and i32 %60, 8388607, !dbg !1003
  %64 = icmp ne i32 %63, 0, !dbg !1003
  %is_subnormal = and i1 %62, %64, !dbg !1003
  %65 = xor i1 %is_subnormal, true, !dbg !1003
  %66 = and i1 true, %65, !dbg !1003
  %67 = and i1 %66, true, !dbg !1003
  %68 = bitcast float %div to i32, !dbg !1003
  %69 = and i32 %68, 2139095040, !dbg !1003
  %70 = icmp eq i32 %69, 0, !dbg !1003
  %71 = and i32 %68, 8388607, !dbg !1003
  %72 = icmp ne i32 %71, 0, !dbg !1003
  %is_subnormal4 = and i1 %70, %72, !dbg !1003
  %73 = bitcast float %div to i32, !dbg !1003
  %74 = and i32 %73, 2147483647, !dbg !1003
  %is_zero5 = icmp eq i32 %74, 0, !dbg !1003
  %75 = bitcast float %9 to i32, !dbg !1003
  %76 = and i32 %75, 2147483647, !dbg !1003
  %is_zero6 = icmp eq i32 %76, 0, !dbg !1003
  %77 = xor i1 %is_zero6, true, !dbg !1003
  %78 = and i1 %77, true, !dbg !1003
  %79 = and i1 %is_zero5, %78, !dbg !1003
  %is_tiny = or i1 %is_subnormal4, %79, !dbg !1003
  %underflow_cond = and i1 %67, %is_tiny, !dbg !1003
  br i1 %underflow_cond, label %80, label %82, !dbg !1003

80:                                               ; preds = %59
  %81 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1003
  br label %82, !dbg !1003

82:                                               ; preds = %59, %80
  %83 = bitcast float %9 to i32, !dbg !1003
  %84 = and i32 %83, 2139095040, !dbg !1003
  %85 = icmp eq i32 %84, 0, !dbg !1003
  %86 = and i32 %83, 8388607, !dbg !1003
  %87 = icmp ne i32 %86, 0, !dbg !1003
  %is_subnormal7 = and i1 %85, %87, !dbg !1003
  %88 = xor i1 %is_subnormal7, true, !dbg !1003
  %89 = and i1 true, %88, !dbg !1003
  %90 = and i1 %89, true, !dbg !1003
  %91 = bitcast float %div to i32, !dbg !1003
  %92 = and i32 %91, 2139095040, !dbg !1003
  %93 = icmp eq i32 %92, 0, !dbg !1003
  %94 = and i32 %91, 8388607, !dbg !1003
  %95 = icmp ne i32 %94, 0, !dbg !1003
  %is_subnormal8 = and i1 %93, %95, !dbg !1003
  %subnormal_cond = and i1 %90, %is_subnormal8, !dbg !1003
  br i1 %subnormal_cond, label %96, label %98, !dbg !1003

96:                                               ; preds = %82
  %97 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1003
  br label %98, !dbg !1003

98:                                               ; preds = %82, %96
  %99 = load ptr, ptr %result.addr, align 8, !dbg !1003
  %arrayidx6 = getelementptr inbounds float, ptr %99, i64 1, !dbg !1003
  store float %div, ptr %arrayidx6, align 4, !dbg !1004
  %100 = load ptr, ptr %result.addr, align 8, !dbg !1005
  %arrayidx7 = getelementptr inbounds float, ptr %100, i64 1, !dbg !1005
  %101 = load float, ptr %arrayidx7, align 4, !dbg !1005
  %call8 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %101) #3, !dbg !1006
  %102 = zext i1 %call8 to i64, !dbg !1006
  %cond9 = select i1 %call8, i32 2, i32 1, !dbg !1006
  %103 = load ptr, ptr %status.addr, align 8, !dbg !1007
  %arrayidx10 = getelementptr inbounds i32, ptr %103, i64 1, !dbg !1007
  store i32 %cond9, ptr %arrayidx10, align 4, !dbg !1008
  br label %if.end11, !dbg !1009

if.end11:                                         ; preds = %98, %if.end
  %104 = load i32, ptr %idx, align 4, !dbg !1010
  %cmp12 = icmp eq i32 %104, 2, !dbg !1012
  br i1 %cmp12, label %if.then13, label %if.end20, !dbg !1012

if.then13:                                        ; preds = %if.end11
  %105 = load float, ptr %base, align 4, !dbg !1013
  %106 = bitcast float %105 to i32, !dbg !1015
  %107 = bitcast float %105 to i32, !dbg !1015
  %108 = and i32 %107, 2139095040, !dbg !1015
  %109 = icmp eq i32 %108, 2139095040, !dbg !1015
  %110 = and i32 %107, 8388607, !dbg !1015
  %111 = icmp ne i32 %110, 0, !dbg !1015
  %is_nan9 = and i1 %109, %111, !dbg !1015
  %112 = and i32 %106, 4194304, !dbg !1015
  %113 = icmp eq i32 %112, 0, !dbg !1015
  %is_snan10 = and i1 %is_nan9, %113, !dbg !1015
  %114 = or i1 %is_snan10, false, !dbg !1015
  %115 = bitcast float %105 to i32, !dbg !1015
  %116 = and i32 %115, 2147483647, !dbg !1015
  %is_zero11 = icmp eq i32 %116, 0, !dbg !1015
  %117 = and i1 %is_zero11, false, !dbg !1015
  %118 = bitcast float %105 to i32, !dbg !1015
  %119 = and i32 %118, 2139095040, !dbg !1015
  %120 = icmp eq i32 %119, 2139095040, !dbg !1015
  %121 = and i32 %118, 8388607, !dbg !1015
  %122 = icmp eq i32 %121, 0, !dbg !1015
  %is_inf12 = and i1 %120, %122, !dbg !1015
  %123 = and i1 %is_inf12, false, !dbg !1015
  %124 = or i1 %117, %123, !dbg !1015
  %125 = or i1 %114, %124, !dbg !1015
  br i1 %125, label %126, label %128, !dbg !1015

126:                                              ; preds = %if.then13
  %127 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1015
  br label %128, !dbg !1015

128:                                              ; preds = %if.then13, %126
  %129 = bitcast float %105 to i32, !dbg !1015
  %130 = and i32 %129, 2139095040, !dbg !1015
  %is_finite13 = icmp ne i32 %130, 2139095040, !dbg !1015
  %131 = bitcast float %105 to i32, !dbg !1015
  %132 = and i32 %131, 2147483647, !dbg !1015
  %is_zero14 = icmp eq i32 %132, 0, !dbg !1015
  %133 = xor i1 %is_zero14, true, !dbg !1015
  %134 = and i1 %is_finite13, %133, !dbg !1015
  %divzero_cond15 = and i1 false, %134, !dbg !1015
  br i1 %divzero_cond15, label %135, label %137, !dbg !1015

135:                                              ; preds = %128
  %136 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1015
  br label %137, !dbg !1015

137:                                              ; preds = %128, %135
  %div14 = fdiv contract float %105, 4.000000e+00, !dbg !1015
  %138 = bitcast float %105 to i32, !dbg !1016
  %139 = and i32 %138, 2139095040, !dbg !1016
  %is_finite16 = icmp ne i32 %139, 2139095040, !dbg !1016
  %140 = and i1 true, %is_finite16, !dbg !1016
  %141 = and i1 %140, true, !dbg !1016
  %overflow_denom_nonzero17 = and i1 %141, true, !dbg !1016
  %142 = bitcast float %div14 to i32, !dbg !1016
  %143 = and i32 %142, 2139095040, !dbg !1016
  %144 = icmp eq i32 %143, 2139095040, !dbg !1016
  %145 = and i32 %142, 8388607, !dbg !1016
  %146 = icmp eq i32 %145, 0, !dbg !1016
  %is_inf18 = and i1 %144, %146, !dbg !1016
  %147 = bitcast float %div14 to i32, !dbg !1016
  %148 = and i32 %147, 2147483647, !dbg !1016
  %is_maxfinite19 = icmp eq i32 %148, 2139095039, !dbg !1016
  %149 = bitcast float %div14 to i32, !dbg !1016
  %150 = and i32 %149, -2147483648, !dbg !1016
  %151 = icmp eq i32 %150, 0, !dbg !1016
  %152 = icmp ne i32 %150, 0, !dbg !1016
  %is_pos_inf20 = and i1 %is_inf18, %151, !dbg !1016
  %is_neg_inf21 = and i1 %is_inf18, %152, !dbg !1016
  %is_pos_max22 = and i1 %is_maxfinite19, %151, !dbg !1016
  %is_neg_max23 = and i1 %is_maxfinite19, %152, !dbg !1016
  %overflow_cond24 = and i1 %overflow_denom_nonzero17, %is_inf18, !dbg !1016
  br i1 %overflow_cond24, label %153, label %155, !dbg !1016

153:                                              ; preds = %137
  %154 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1016
  br label %155, !dbg !1016

155:                                              ; preds = %137, %153
  %156 = bitcast float %105 to i32, !dbg !1016
  %157 = and i32 %156, 2139095040, !dbg !1016
  %158 = icmp eq i32 %157, 0, !dbg !1016
  %159 = and i32 %156, 8388607, !dbg !1016
  %160 = icmp ne i32 %159, 0, !dbg !1016
  %is_subnormal25 = and i1 %158, %160, !dbg !1016
  %161 = xor i1 %is_subnormal25, true, !dbg !1016
  %162 = and i1 true, %161, !dbg !1016
  %163 = and i1 %162, true, !dbg !1016
  %164 = bitcast float %div14 to i32, !dbg !1016
  %165 = and i32 %164, 2139095040, !dbg !1016
  %166 = icmp eq i32 %165, 0, !dbg !1016
  %167 = and i32 %164, 8388607, !dbg !1016
  %168 = icmp ne i32 %167, 0, !dbg !1016
  %is_subnormal26 = and i1 %166, %168, !dbg !1016
  %169 = bitcast float %div14 to i32, !dbg !1016
  %170 = and i32 %169, 2147483647, !dbg !1016
  %is_zero27 = icmp eq i32 %170, 0, !dbg !1016
  %171 = bitcast float %105 to i32, !dbg !1016
  %172 = and i32 %171, 2147483647, !dbg !1016
  %is_zero28 = icmp eq i32 %172, 0, !dbg !1016
  %173 = xor i1 %is_zero28, true, !dbg !1016
  %174 = and i1 %173, true, !dbg !1016
  %175 = and i1 %is_zero27, %174, !dbg !1016
  %is_tiny29 = or i1 %is_subnormal26, %175, !dbg !1016
  %underflow_cond30 = and i1 %163, %is_tiny29, !dbg !1016
  br i1 %underflow_cond30, label %176, label %178, !dbg !1016

176:                                              ; preds = %155
  %177 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1016
  br label %178, !dbg !1016

178:                                              ; preds = %155, %176
  %179 = bitcast float %105 to i32, !dbg !1016
  %180 = and i32 %179, 2139095040, !dbg !1016
  %181 = icmp eq i32 %180, 0, !dbg !1016
  %182 = and i32 %179, 8388607, !dbg !1016
  %183 = icmp ne i32 %182, 0, !dbg !1016
  %is_subnormal31 = and i1 %181, %183, !dbg !1016
  %184 = xor i1 %is_subnormal31, true, !dbg !1016
  %185 = and i1 true, %184, !dbg !1016
  %186 = and i1 %185, true, !dbg !1016
  %187 = bitcast float %div14 to i32, !dbg !1016
  %188 = and i32 %187, 2139095040, !dbg !1016
  %189 = icmp eq i32 %188, 0, !dbg !1016
  %190 = and i32 %187, 8388607, !dbg !1016
  %191 = icmp ne i32 %190, 0, !dbg !1016
  %is_subnormal32 = and i1 %189, %191, !dbg !1016
  %subnormal_cond33 = and i1 %186, %is_subnormal32, !dbg !1016
  br i1 %subnormal_cond33, label %192, label %194, !dbg !1016

192:                                              ; preds = %178
  %193 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1016
  br label %194, !dbg !1016

194:                                              ; preds = %178, %192
  %195 = load ptr, ptr %result.addr, align 8, !dbg !1016
  %arrayidx15 = getelementptr inbounds float, ptr %195, i64 2, !dbg !1016
  store float %div14, ptr %arrayidx15, align 4, !dbg !1017
  %196 = load ptr, ptr %result.addr, align 8, !dbg !1018
  %arrayidx16 = getelementptr inbounds float, ptr %196, i64 2, !dbg !1018
  %197 = load float, ptr %arrayidx16, align 4, !dbg !1018
  %call17 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %197) #3, !dbg !1019
  %198 = zext i1 %call17 to i64, !dbg !1019
  %cond18 = select i1 %call17, i32 2, i32 1, !dbg !1019
  %199 = load ptr, ptr %status.addr, align 8, !dbg !1020
  %arrayidx19 = getelementptr inbounds i32, ptr %199, i64 2, !dbg !1020
  store i32 %cond18, ptr %arrayidx19, align 4, !dbg !1021
  br label %if.end20, !dbg !1022

if.end20:                                         ; preds = %194, %if.end11
  %200 = load i32, ptr %idx, align 4, !dbg !1023
  %cmp21 = icmp eq i32 %200, 3, !dbg !1025
  br i1 %cmp21, label %if.then22, label %if.end29, !dbg !1025

if.then22:                                        ; preds = %if.end20
  %201 = load float, ptr %base, align 4, !dbg !1026
  %202 = bitcast float %201 to i32, !dbg !1028
  %203 = bitcast float %201 to i32, !dbg !1028
  %204 = and i32 %203, 2139095040, !dbg !1028
  %205 = icmp eq i32 %204, 2139095040, !dbg !1028
  %206 = and i32 %203, 8388607, !dbg !1028
  %207 = icmp ne i32 %206, 0, !dbg !1028
  %is_nan34 = and i1 %205, %207, !dbg !1028
  %208 = and i32 %202, 4194304, !dbg !1028
  %209 = icmp eq i32 %208, 0, !dbg !1028
  %is_snan35 = and i1 %is_nan34, %209, !dbg !1028
  %210 = or i1 %is_snan35, false, !dbg !1028
  %211 = bitcast float %201 to i32, !dbg !1028
  %212 = and i32 %211, 2147483647, !dbg !1028
  %is_zero36 = icmp eq i32 %212, 0, !dbg !1028
  %213 = and i1 %is_zero36, false, !dbg !1028
  %214 = bitcast float %201 to i32, !dbg !1028
  %215 = and i32 %214, 2139095040, !dbg !1028
  %216 = icmp eq i32 %215, 2139095040, !dbg !1028
  %217 = and i32 %214, 8388607, !dbg !1028
  %218 = icmp eq i32 %217, 0, !dbg !1028
  %is_inf37 = and i1 %216, %218, !dbg !1028
  %219 = and i1 %is_inf37, false, !dbg !1028
  %220 = or i1 %213, %219, !dbg !1028
  %221 = or i1 %210, %220, !dbg !1028
  br i1 %221, label %222, label %224, !dbg !1028

222:                                              ; preds = %if.then22
  %223 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1028
  br label %224, !dbg !1028

224:                                              ; preds = %if.then22, %222
  %225 = bitcast float %201 to i32, !dbg !1028
  %226 = and i32 %225, 2139095040, !dbg !1028
  %is_finite38 = icmp ne i32 %226, 2139095040, !dbg !1028
  %227 = bitcast float %201 to i32, !dbg !1028
  %228 = and i32 %227, 2147483647, !dbg !1028
  %is_zero39 = icmp eq i32 %228, 0, !dbg !1028
  %229 = xor i1 %is_zero39, true, !dbg !1028
  %230 = and i1 %is_finite38, %229, !dbg !1028
  %divzero_cond40 = and i1 false, %230, !dbg !1028
  br i1 %divzero_cond40, label %231, label %233, !dbg !1028

231:                                              ; preds = %224
  %232 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1028
  br label %233, !dbg !1028

233:                                              ; preds = %224, %231
  %div23 = fdiv contract float %201, 8.000000e+00, !dbg !1028
  %234 = bitcast float %201 to i32, !dbg !1029
  %235 = and i32 %234, 2139095040, !dbg !1029
  %is_finite41 = icmp ne i32 %235, 2139095040, !dbg !1029
  %236 = and i1 true, %is_finite41, !dbg !1029
  %237 = and i1 %236, true, !dbg !1029
  %overflow_denom_nonzero42 = and i1 %237, true, !dbg !1029
  %238 = bitcast float %div23 to i32, !dbg !1029
  %239 = and i32 %238, 2139095040, !dbg !1029
  %240 = icmp eq i32 %239, 2139095040, !dbg !1029
  %241 = and i32 %238, 8388607, !dbg !1029
  %242 = icmp eq i32 %241, 0, !dbg !1029
  %is_inf43 = and i1 %240, %242, !dbg !1029
  %243 = bitcast float %div23 to i32, !dbg !1029
  %244 = and i32 %243, 2147483647, !dbg !1029
  %is_maxfinite44 = icmp eq i32 %244, 2139095039, !dbg !1029
  %245 = bitcast float %div23 to i32, !dbg !1029
  %246 = and i32 %245, -2147483648, !dbg !1029
  %247 = icmp eq i32 %246, 0, !dbg !1029
  %248 = icmp ne i32 %246, 0, !dbg !1029
  %is_pos_inf45 = and i1 %is_inf43, %247, !dbg !1029
  %is_neg_inf46 = and i1 %is_inf43, %248, !dbg !1029
  %is_pos_max47 = and i1 %is_maxfinite44, %247, !dbg !1029
  %is_neg_max48 = and i1 %is_maxfinite44, %248, !dbg !1029
  %overflow_cond49 = and i1 %overflow_denom_nonzero42, %is_inf43, !dbg !1029
  br i1 %overflow_cond49, label %249, label %251, !dbg !1029

249:                                              ; preds = %233
  %250 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1029
  br label %251, !dbg !1029

251:                                              ; preds = %233, %249
  %252 = bitcast float %201 to i32, !dbg !1029
  %253 = and i32 %252, 2139095040, !dbg !1029
  %254 = icmp eq i32 %253, 0, !dbg !1029
  %255 = and i32 %252, 8388607, !dbg !1029
  %256 = icmp ne i32 %255, 0, !dbg !1029
  %is_subnormal50 = and i1 %254, %256, !dbg !1029
  %257 = xor i1 %is_subnormal50, true, !dbg !1029
  %258 = and i1 true, %257, !dbg !1029
  %259 = and i1 %258, true, !dbg !1029
  %260 = bitcast float %div23 to i32, !dbg !1029
  %261 = and i32 %260, 2139095040, !dbg !1029
  %262 = icmp eq i32 %261, 0, !dbg !1029
  %263 = and i32 %260, 8388607, !dbg !1029
  %264 = icmp ne i32 %263, 0, !dbg !1029
  %is_subnormal51 = and i1 %262, %264, !dbg !1029
  %265 = bitcast float %div23 to i32, !dbg !1029
  %266 = and i32 %265, 2147483647, !dbg !1029
  %is_zero52 = icmp eq i32 %266, 0, !dbg !1029
  %267 = bitcast float %201 to i32, !dbg !1029
  %268 = and i32 %267, 2147483647, !dbg !1029
  %is_zero53 = icmp eq i32 %268, 0, !dbg !1029
  %269 = xor i1 %is_zero53, true, !dbg !1029
  %270 = and i1 %269, true, !dbg !1029
  %271 = and i1 %is_zero52, %270, !dbg !1029
  %is_tiny54 = or i1 %is_subnormal51, %271, !dbg !1029
  %underflow_cond55 = and i1 %259, %is_tiny54, !dbg !1029
  br i1 %underflow_cond55, label %272, label %274, !dbg !1029

272:                                              ; preds = %251
  %273 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1029
  br label %274, !dbg !1029

274:                                              ; preds = %251, %272
  %275 = bitcast float %201 to i32, !dbg !1029
  %276 = and i32 %275, 2139095040, !dbg !1029
  %277 = icmp eq i32 %276, 0, !dbg !1029
  %278 = and i32 %275, 8388607, !dbg !1029
  %279 = icmp ne i32 %278, 0, !dbg !1029
  %is_subnormal56 = and i1 %277, %279, !dbg !1029
  %280 = xor i1 %is_subnormal56, true, !dbg !1029
  %281 = and i1 true, %280, !dbg !1029
  %282 = and i1 %281, true, !dbg !1029
  %283 = bitcast float %div23 to i32, !dbg !1029
  %284 = and i32 %283, 2139095040, !dbg !1029
  %285 = icmp eq i32 %284, 0, !dbg !1029
  %286 = and i32 %283, 8388607, !dbg !1029
  %287 = icmp ne i32 %286, 0, !dbg !1029
  %is_subnormal57 = and i1 %285, %287, !dbg !1029
  %subnormal_cond58 = and i1 %282, %is_subnormal57, !dbg !1029
  br i1 %subnormal_cond58, label %288, label %290, !dbg !1029

288:                                              ; preds = %274
  %289 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1029
  br label %290, !dbg !1029

290:                                              ; preds = %274, %288
  %291 = load ptr, ptr %result.addr, align 8, !dbg !1029
  %arrayidx24 = getelementptr inbounds float, ptr %291, i64 3, !dbg !1029
  store float %div23, ptr %arrayidx24, align 4, !dbg !1030
  %292 = load ptr, ptr %result.addr, align 8, !dbg !1031
  %arrayidx25 = getelementptr inbounds float, ptr %292, i64 3, !dbg !1031
  %293 = load float, ptr %arrayidx25, align 4, !dbg !1031
  %call26 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %293) #3, !dbg !1032
  %294 = zext i1 %call26 to i64, !dbg !1032
  %cond27 = select i1 %call26, i32 2, i32 1, !dbg !1032
  %295 = load ptr, ptr %status.addr, align 8, !dbg !1033
  %arrayidx28 = getelementptr inbounds i32, ptr %295, i64 3, !dbg !1033
  store i32 %cond27, ptr %arrayidx28, align 4, !dbg !1034
  br label %if.end29, !dbg !1035

if.end29:                                         ; preds = %290, %if.end20
  %296 = load i32, ptr %idx, align 4, !dbg !1036
  %cmp30 = icmp eq i32 %296, 4, !dbg !1038
  br i1 %cmp30, label %if.then31, label %if.end38, !dbg !1038

if.then31:                                        ; preds = %if.end29
  %297 = load float, ptr %base, align 4, !dbg !1039
  %298 = bitcast float %297 to i32, !dbg !1041
  %299 = bitcast float %297 to i32, !dbg !1041
  %300 = and i32 %299, 2139095040, !dbg !1041
  %301 = icmp eq i32 %300, 2139095040, !dbg !1041
  %302 = and i32 %299, 8388607, !dbg !1041
  %303 = icmp ne i32 %302, 0, !dbg !1041
  %is_nan59 = and i1 %301, %303, !dbg !1041
  %304 = and i32 %298, 4194304, !dbg !1041
  %305 = icmp eq i32 %304, 0, !dbg !1041
  %is_snan60 = and i1 %is_nan59, %305, !dbg !1041
  %306 = or i1 %is_snan60, false, !dbg !1041
  %307 = bitcast float %297 to i32, !dbg !1041
  %308 = and i32 %307, 2147483647, !dbg !1041
  %is_zero61 = icmp eq i32 %308, 0, !dbg !1041
  %309 = and i1 %is_zero61, false, !dbg !1041
  %310 = bitcast float %297 to i32, !dbg !1041
  %311 = and i32 %310, 2139095040, !dbg !1041
  %312 = icmp eq i32 %311, 2139095040, !dbg !1041
  %313 = and i32 %310, 8388607, !dbg !1041
  %314 = icmp eq i32 %313, 0, !dbg !1041
  %is_inf62 = and i1 %312, %314, !dbg !1041
  %315 = and i1 %is_inf62, false, !dbg !1041
  %316 = or i1 %309, %315, !dbg !1041
  %317 = or i1 %306, %316, !dbg !1041
  br i1 %317, label %318, label %320, !dbg !1041

318:                                              ; preds = %if.then31
  %319 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1041
  br label %320, !dbg !1041

320:                                              ; preds = %if.then31, %318
  %321 = bitcast float %297 to i32, !dbg !1041
  %322 = and i32 %321, 2139095040, !dbg !1041
  %is_finite63 = icmp ne i32 %322, 2139095040, !dbg !1041
  %323 = bitcast float %297 to i32, !dbg !1041
  %324 = and i32 %323, 2147483647, !dbg !1041
  %is_zero64 = icmp eq i32 %324, 0, !dbg !1041
  %325 = xor i1 %is_zero64, true, !dbg !1041
  %326 = and i1 %is_finite63, %325, !dbg !1041
  %divzero_cond65 = and i1 false, %326, !dbg !1041
  br i1 %divzero_cond65, label %327, label %329, !dbg !1041

327:                                              ; preds = %320
  %328 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1041
  br label %329, !dbg !1041

329:                                              ; preds = %320, %327
  %div32 = fdiv contract float %297, 1.600000e+01, !dbg !1041
  %330 = bitcast float %297 to i32, !dbg !1042
  %331 = and i32 %330, 2139095040, !dbg !1042
  %is_finite66 = icmp ne i32 %331, 2139095040, !dbg !1042
  %332 = and i1 true, %is_finite66, !dbg !1042
  %333 = and i1 %332, true, !dbg !1042
  %overflow_denom_nonzero67 = and i1 %333, true, !dbg !1042
  %334 = bitcast float %div32 to i32, !dbg !1042
  %335 = and i32 %334, 2139095040, !dbg !1042
  %336 = icmp eq i32 %335, 2139095040, !dbg !1042
  %337 = and i32 %334, 8388607, !dbg !1042
  %338 = icmp eq i32 %337, 0, !dbg !1042
  %is_inf68 = and i1 %336, %338, !dbg !1042
  %339 = bitcast float %div32 to i32, !dbg !1042
  %340 = and i32 %339, 2147483647, !dbg !1042
  %is_maxfinite69 = icmp eq i32 %340, 2139095039, !dbg !1042
  %341 = bitcast float %div32 to i32, !dbg !1042
  %342 = and i32 %341, -2147483648, !dbg !1042
  %343 = icmp eq i32 %342, 0, !dbg !1042
  %344 = icmp ne i32 %342, 0, !dbg !1042
  %is_pos_inf70 = and i1 %is_inf68, %343, !dbg !1042
  %is_neg_inf71 = and i1 %is_inf68, %344, !dbg !1042
  %is_pos_max72 = and i1 %is_maxfinite69, %343, !dbg !1042
  %is_neg_max73 = and i1 %is_maxfinite69, %344, !dbg !1042
  %overflow_cond74 = and i1 %overflow_denom_nonzero67, %is_inf68, !dbg !1042
  br i1 %overflow_cond74, label %345, label %347, !dbg !1042

345:                                              ; preds = %329
  %346 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1042
  br label %347, !dbg !1042

347:                                              ; preds = %329, %345
  %348 = bitcast float %297 to i32, !dbg !1042
  %349 = and i32 %348, 2139095040, !dbg !1042
  %350 = icmp eq i32 %349, 0, !dbg !1042
  %351 = and i32 %348, 8388607, !dbg !1042
  %352 = icmp ne i32 %351, 0, !dbg !1042
  %is_subnormal75 = and i1 %350, %352, !dbg !1042
  %353 = xor i1 %is_subnormal75, true, !dbg !1042
  %354 = and i1 true, %353, !dbg !1042
  %355 = and i1 %354, true, !dbg !1042
  %356 = bitcast float %div32 to i32, !dbg !1042
  %357 = and i32 %356, 2139095040, !dbg !1042
  %358 = icmp eq i32 %357, 0, !dbg !1042
  %359 = and i32 %356, 8388607, !dbg !1042
  %360 = icmp ne i32 %359, 0, !dbg !1042
  %is_subnormal76 = and i1 %358, %360, !dbg !1042
  %361 = bitcast float %div32 to i32, !dbg !1042
  %362 = and i32 %361, 2147483647, !dbg !1042
  %is_zero77 = icmp eq i32 %362, 0, !dbg !1042
  %363 = bitcast float %297 to i32, !dbg !1042
  %364 = and i32 %363, 2147483647, !dbg !1042
  %is_zero78 = icmp eq i32 %364, 0, !dbg !1042
  %365 = xor i1 %is_zero78, true, !dbg !1042
  %366 = and i1 %365, true, !dbg !1042
  %367 = and i1 %is_zero77, %366, !dbg !1042
  %is_tiny79 = or i1 %is_subnormal76, %367, !dbg !1042
  %underflow_cond80 = and i1 %355, %is_tiny79, !dbg !1042
  br i1 %underflow_cond80, label %368, label %370, !dbg !1042

368:                                              ; preds = %347
  %369 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1042
  br label %370, !dbg !1042

370:                                              ; preds = %347, %368
  %371 = bitcast float %297 to i32, !dbg !1042
  %372 = and i32 %371, 2139095040, !dbg !1042
  %373 = icmp eq i32 %372, 0, !dbg !1042
  %374 = and i32 %371, 8388607, !dbg !1042
  %375 = icmp ne i32 %374, 0, !dbg !1042
  %is_subnormal81 = and i1 %373, %375, !dbg !1042
  %376 = xor i1 %is_subnormal81, true, !dbg !1042
  %377 = and i1 true, %376, !dbg !1042
  %378 = and i1 %377, true, !dbg !1042
  %379 = bitcast float %div32 to i32, !dbg !1042
  %380 = and i32 %379, 2139095040, !dbg !1042
  %381 = icmp eq i32 %380, 0, !dbg !1042
  %382 = and i32 %379, 8388607, !dbg !1042
  %383 = icmp ne i32 %382, 0, !dbg !1042
  %is_subnormal82 = and i1 %381, %383, !dbg !1042
  %subnormal_cond83 = and i1 %378, %is_subnormal82, !dbg !1042
  br i1 %subnormal_cond83, label %384, label %386, !dbg !1042

384:                                              ; preds = %370
  %385 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1042
  br label %386, !dbg !1042

386:                                              ; preds = %370, %384
  %387 = load ptr, ptr %result.addr, align 8, !dbg !1042
  %arrayidx33 = getelementptr inbounds float, ptr %387, i64 4, !dbg !1042
  store float %div32, ptr %arrayidx33, align 4, !dbg !1043
  %388 = load ptr, ptr %result.addr, align 8, !dbg !1044
  %arrayidx34 = getelementptr inbounds float, ptr %388, i64 4, !dbg !1044
  %389 = load float, ptr %arrayidx34, align 4, !dbg !1044
  %call35 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %389) #3, !dbg !1045
  %390 = zext i1 %call35 to i64, !dbg !1045
  %cond36 = select i1 %call35, i32 2, i32 1, !dbg !1045
  %391 = load ptr, ptr %status.addr, align 8, !dbg !1046
  %arrayidx37 = getelementptr inbounds i32, ptr %391, i64 4, !dbg !1046
  store i32 %cond36, ptr %arrayidx37, align 4, !dbg !1047
  br label %if.end38, !dbg !1048

if.end38:                                         ; preds = %386, %if.end29
  %392 = load i32, ptr %idx, align 4, !dbg !1049
  %cmp39 = icmp eq i32 %392, 5, !dbg !1051
  br i1 %cmp39, label %if.then40, label %if.end47, !dbg !1051

if.then40:                                        ; preds = %if.end38
  %393 = load float, ptr %base, align 4, !dbg !1052
  %394 = bitcast float %393 to i32, !dbg !1054
  %395 = bitcast float %393 to i32, !dbg !1054
  %396 = and i32 %395, 2139095040, !dbg !1054
  %397 = icmp eq i32 %396, 2139095040, !dbg !1054
  %398 = and i32 %395, 8388607, !dbg !1054
  %399 = icmp ne i32 %398, 0, !dbg !1054
  %is_nan84 = and i1 %397, %399, !dbg !1054
  %400 = and i32 %394, 4194304, !dbg !1054
  %401 = icmp eq i32 %400, 0, !dbg !1054
  %is_snan85 = and i1 %is_nan84, %401, !dbg !1054
  %402 = or i1 %is_snan85, false, !dbg !1054
  %403 = bitcast float %393 to i32, !dbg !1054
  %404 = and i32 %403, 2147483647, !dbg !1054
  %is_zero86 = icmp eq i32 %404, 0, !dbg !1054
  %405 = and i1 %is_zero86, false, !dbg !1054
  %406 = bitcast float %393 to i32, !dbg !1054
  %407 = and i32 %406, 2139095040, !dbg !1054
  %408 = icmp eq i32 %407, 2139095040, !dbg !1054
  %409 = and i32 %406, 8388607, !dbg !1054
  %410 = icmp eq i32 %409, 0, !dbg !1054
  %is_inf87 = and i1 %408, %410, !dbg !1054
  %411 = and i1 %is_inf87, false, !dbg !1054
  %412 = or i1 %405, %411, !dbg !1054
  %413 = or i1 %402, %412, !dbg !1054
  br i1 %413, label %414, label %416, !dbg !1054

414:                                              ; preds = %if.then40
  %415 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1054
  br label %416, !dbg !1054

416:                                              ; preds = %if.then40, %414
  %417 = bitcast float %393 to i32, !dbg !1054
  %418 = and i32 %417, 2139095040, !dbg !1054
  %is_finite88 = icmp ne i32 %418, 2139095040, !dbg !1054
  %419 = bitcast float %393 to i32, !dbg !1054
  %420 = and i32 %419, 2147483647, !dbg !1054
  %is_zero89 = icmp eq i32 %420, 0, !dbg !1054
  %421 = xor i1 %is_zero89, true, !dbg !1054
  %422 = and i1 %is_finite88, %421, !dbg !1054
  %divzero_cond90 = and i1 false, %422, !dbg !1054
  br i1 %divzero_cond90, label %423, label %425, !dbg !1054

423:                                              ; preds = %416
  %424 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1054
  br label %425, !dbg !1054

425:                                              ; preds = %416, %423
  %div41 = fdiv contract float %393, 1.024000e+03, !dbg !1054
  %426 = bitcast float %393 to i32, !dbg !1055
  %427 = and i32 %426, 2139095040, !dbg !1055
  %is_finite91 = icmp ne i32 %427, 2139095040, !dbg !1055
  %428 = and i1 true, %is_finite91, !dbg !1055
  %429 = and i1 %428, true, !dbg !1055
  %overflow_denom_nonzero92 = and i1 %429, true, !dbg !1055
  %430 = bitcast float %div41 to i32, !dbg !1055
  %431 = and i32 %430, 2139095040, !dbg !1055
  %432 = icmp eq i32 %431, 2139095040, !dbg !1055
  %433 = and i32 %430, 8388607, !dbg !1055
  %434 = icmp eq i32 %433, 0, !dbg !1055
  %is_inf93 = and i1 %432, %434, !dbg !1055
  %435 = bitcast float %div41 to i32, !dbg !1055
  %436 = and i32 %435, 2147483647, !dbg !1055
  %is_maxfinite94 = icmp eq i32 %436, 2139095039, !dbg !1055
  %437 = bitcast float %div41 to i32, !dbg !1055
  %438 = and i32 %437, -2147483648, !dbg !1055
  %439 = icmp eq i32 %438, 0, !dbg !1055
  %440 = icmp ne i32 %438, 0, !dbg !1055
  %is_pos_inf95 = and i1 %is_inf93, %439, !dbg !1055
  %is_neg_inf96 = and i1 %is_inf93, %440, !dbg !1055
  %is_pos_max97 = and i1 %is_maxfinite94, %439, !dbg !1055
  %is_neg_max98 = and i1 %is_maxfinite94, %440, !dbg !1055
  %overflow_cond99 = and i1 %overflow_denom_nonzero92, %is_inf93, !dbg !1055
  br i1 %overflow_cond99, label %441, label %443, !dbg !1055

441:                                              ; preds = %425
  %442 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1055
  br label %443, !dbg !1055

443:                                              ; preds = %425, %441
  %444 = bitcast float %393 to i32, !dbg !1055
  %445 = and i32 %444, 2139095040, !dbg !1055
  %446 = icmp eq i32 %445, 0, !dbg !1055
  %447 = and i32 %444, 8388607, !dbg !1055
  %448 = icmp ne i32 %447, 0, !dbg !1055
  %is_subnormal100 = and i1 %446, %448, !dbg !1055
  %449 = xor i1 %is_subnormal100, true, !dbg !1055
  %450 = and i1 true, %449, !dbg !1055
  %451 = and i1 %450, true, !dbg !1055
  %452 = bitcast float %div41 to i32, !dbg !1055
  %453 = and i32 %452, 2139095040, !dbg !1055
  %454 = icmp eq i32 %453, 0, !dbg !1055
  %455 = and i32 %452, 8388607, !dbg !1055
  %456 = icmp ne i32 %455, 0, !dbg !1055
  %is_subnormal101 = and i1 %454, %456, !dbg !1055
  %457 = bitcast float %div41 to i32, !dbg !1055
  %458 = and i32 %457, 2147483647, !dbg !1055
  %is_zero102 = icmp eq i32 %458, 0, !dbg !1055
  %459 = bitcast float %393 to i32, !dbg !1055
  %460 = and i32 %459, 2147483647, !dbg !1055
  %is_zero103 = icmp eq i32 %460, 0, !dbg !1055
  %461 = xor i1 %is_zero103, true, !dbg !1055
  %462 = and i1 %461, true, !dbg !1055
  %463 = and i1 %is_zero102, %462, !dbg !1055
  %is_tiny104 = or i1 %is_subnormal101, %463, !dbg !1055
  %underflow_cond105 = and i1 %451, %is_tiny104, !dbg !1055
  br i1 %underflow_cond105, label %464, label %466, !dbg !1055

464:                                              ; preds = %443
  %465 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1055
  br label %466, !dbg !1055

466:                                              ; preds = %443, %464
  %467 = bitcast float %393 to i32, !dbg !1055
  %468 = and i32 %467, 2139095040, !dbg !1055
  %469 = icmp eq i32 %468, 0, !dbg !1055
  %470 = and i32 %467, 8388607, !dbg !1055
  %471 = icmp ne i32 %470, 0, !dbg !1055
  %is_subnormal106 = and i1 %469, %471, !dbg !1055
  %472 = xor i1 %is_subnormal106, true, !dbg !1055
  %473 = and i1 true, %472, !dbg !1055
  %474 = and i1 %473, true, !dbg !1055
  %475 = bitcast float %div41 to i32, !dbg !1055
  %476 = and i32 %475, 2139095040, !dbg !1055
  %477 = icmp eq i32 %476, 0, !dbg !1055
  %478 = and i32 %475, 8388607, !dbg !1055
  %479 = icmp ne i32 %478, 0, !dbg !1055
  %is_subnormal107 = and i1 %477, %479, !dbg !1055
  %subnormal_cond108 = and i1 %474, %is_subnormal107, !dbg !1055
  br i1 %subnormal_cond108, label %480, label %482, !dbg !1055

480:                                              ; preds = %466
  %481 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1055
  br label %482, !dbg !1055

482:                                              ; preds = %466, %480
  %483 = load ptr, ptr %result.addr, align 8, !dbg !1055
  %arrayidx42 = getelementptr inbounds float, ptr %483, i64 5, !dbg !1055
  store float %div41, ptr %arrayidx42, align 4, !dbg !1056
  %484 = load ptr, ptr %result.addr, align 8, !dbg !1057
  %arrayidx43 = getelementptr inbounds float, ptr %484, i64 5, !dbg !1057
  %485 = load float, ptr %arrayidx43, align 4, !dbg !1057
  %call44 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %485) #3, !dbg !1058
  %486 = zext i1 %call44 to i64, !dbg !1058
  %cond45 = select i1 %call44, i32 2, i32 1, !dbg !1058
  %487 = load ptr, ptr %status.addr, align 8, !dbg !1059
  %arrayidx46 = getelementptr inbounds i32, ptr %487, i64 5, !dbg !1059
  store i32 %cond45, ptr %arrayidx46, align 4, !dbg !1060
  br label %if.end47, !dbg !1061

if.end47:                                         ; preds = %482, %if.end38
  %488 = load i32, ptr %idx, align 4, !dbg !1062
  %cmp48 = icmp eq i32 %488, 6, !dbg !1064
  br i1 %cmp48, label %if.then49, label %if.end56, !dbg !1064

if.then49:                                        ; preds = %if.end47
  %489 = load float, ptr %base, align 4, !dbg !1065
  %490 = bitcast float %489 to i32, !dbg !1067
  %491 = bitcast float %489 to i32, !dbg !1067
  %492 = and i32 %491, 2139095040, !dbg !1067
  %493 = icmp eq i32 %492, 2139095040, !dbg !1067
  %494 = and i32 %491, 8388607, !dbg !1067
  %495 = icmp ne i32 %494, 0, !dbg !1067
  %is_nan109 = and i1 %493, %495, !dbg !1067
  %496 = and i32 %490, 4194304, !dbg !1067
  %497 = icmp eq i32 %496, 0, !dbg !1067
  %is_snan110 = and i1 %is_nan109, %497, !dbg !1067
  %498 = or i1 %is_snan110, false, !dbg !1067
  %499 = bitcast float %489 to i32, !dbg !1067
  %500 = and i32 %499, 2147483647, !dbg !1067
  %is_zero111 = icmp eq i32 %500, 0, !dbg !1067
  %501 = and i1 %is_zero111, false, !dbg !1067
  %502 = bitcast float %489 to i32, !dbg !1067
  %503 = and i32 %502, 2139095040, !dbg !1067
  %504 = icmp eq i32 %503, 2139095040, !dbg !1067
  %505 = and i32 %502, 8388607, !dbg !1067
  %506 = icmp eq i32 %505, 0, !dbg !1067
  %is_inf112 = and i1 %504, %506, !dbg !1067
  %507 = and i1 %is_inf112, false, !dbg !1067
  %508 = or i1 %501, %507, !dbg !1067
  %509 = or i1 %498, %508, !dbg !1067
  br i1 %509, label %510, label %512, !dbg !1067

510:                                              ; preds = %if.then49
  %511 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1067
  br label %512, !dbg !1067

512:                                              ; preds = %if.then49, %510
  %513 = bitcast float %489 to i32, !dbg !1067
  %514 = and i32 %513, 2139095040, !dbg !1067
  %is_finite113 = icmp ne i32 %514, 2139095040, !dbg !1067
  %515 = bitcast float %489 to i32, !dbg !1067
  %516 = and i32 %515, 2147483647, !dbg !1067
  %is_zero114 = icmp eq i32 %516, 0, !dbg !1067
  %517 = xor i1 %is_zero114, true, !dbg !1067
  %518 = and i1 %is_finite113, %517, !dbg !1067
  %divzero_cond115 = and i1 false, %518, !dbg !1067
  br i1 %divzero_cond115, label %519, label %521, !dbg !1067

519:                                              ; preds = %512
  %520 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1067
  br label %521, !dbg !1067

521:                                              ; preds = %512, %519
  %div50 = fdiv contract float %489, 0x4130000000000000, !dbg !1067
  %522 = bitcast float %489 to i32, !dbg !1068
  %523 = and i32 %522, 2139095040, !dbg !1068
  %is_finite116 = icmp ne i32 %523, 2139095040, !dbg !1068
  %524 = and i1 true, %is_finite116, !dbg !1068
  %525 = and i1 %524, true, !dbg !1068
  %overflow_denom_nonzero117 = and i1 %525, true, !dbg !1068
  %526 = bitcast float %div50 to i32, !dbg !1068
  %527 = and i32 %526, 2139095040, !dbg !1068
  %528 = icmp eq i32 %527, 2139095040, !dbg !1068
  %529 = and i32 %526, 8388607, !dbg !1068
  %530 = icmp eq i32 %529, 0, !dbg !1068
  %is_inf118 = and i1 %528, %530, !dbg !1068
  %531 = bitcast float %div50 to i32, !dbg !1068
  %532 = and i32 %531, 2147483647, !dbg !1068
  %is_maxfinite119 = icmp eq i32 %532, 2139095039, !dbg !1068
  %533 = bitcast float %div50 to i32, !dbg !1068
  %534 = and i32 %533, -2147483648, !dbg !1068
  %535 = icmp eq i32 %534, 0, !dbg !1068
  %536 = icmp ne i32 %534, 0, !dbg !1068
  %is_pos_inf120 = and i1 %is_inf118, %535, !dbg !1068
  %is_neg_inf121 = and i1 %is_inf118, %536, !dbg !1068
  %is_pos_max122 = and i1 %is_maxfinite119, %535, !dbg !1068
  %is_neg_max123 = and i1 %is_maxfinite119, %536, !dbg !1068
  %overflow_cond124 = and i1 %overflow_denom_nonzero117, %is_inf118, !dbg !1068
  br i1 %overflow_cond124, label %537, label %539, !dbg !1068

537:                                              ; preds = %521
  %538 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1068
  br label %539, !dbg !1068

539:                                              ; preds = %521, %537
  %540 = bitcast float %489 to i32, !dbg !1068
  %541 = and i32 %540, 2139095040, !dbg !1068
  %542 = icmp eq i32 %541, 0, !dbg !1068
  %543 = and i32 %540, 8388607, !dbg !1068
  %544 = icmp ne i32 %543, 0, !dbg !1068
  %is_subnormal125 = and i1 %542, %544, !dbg !1068
  %545 = xor i1 %is_subnormal125, true, !dbg !1068
  %546 = and i1 true, %545, !dbg !1068
  %547 = and i1 %546, true, !dbg !1068
  %548 = bitcast float %div50 to i32, !dbg !1068
  %549 = and i32 %548, 2139095040, !dbg !1068
  %550 = icmp eq i32 %549, 0, !dbg !1068
  %551 = and i32 %548, 8388607, !dbg !1068
  %552 = icmp ne i32 %551, 0, !dbg !1068
  %is_subnormal126 = and i1 %550, %552, !dbg !1068
  %553 = bitcast float %div50 to i32, !dbg !1068
  %554 = and i32 %553, 2147483647, !dbg !1068
  %is_zero127 = icmp eq i32 %554, 0, !dbg !1068
  %555 = bitcast float %489 to i32, !dbg !1068
  %556 = and i32 %555, 2147483647, !dbg !1068
  %is_zero128 = icmp eq i32 %556, 0, !dbg !1068
  %557 = xor i1 %is_zero128, true, !dbg !1068
  %558 = and i1 %557, true, !dbg !1068
  %559 = and i1 %is_zero127, %558, !dbg !1068
  %is_tiny129 = or i1 %is_subnormal126, %559, !dbg !1068
  %underflow_cond130 = and i1 %547, %is_tiny129, !dbg !1068
  br i1 %underflow_cond130, label %560, label %562, !dbg !1068

560:                                              ; preds = %539
  %561 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1068
  br label %562, !dbg !1068

562:                                              ; preds = %539, %560
  %563 = bitcast float %489 to i32, !dbg !1068
  %564 = and i32 %563, 2139095040, !dbg !1068
  %565 = icmp eq i32 %564, 0, !dbg !1068
  %566 = and i32 %563, 8388607, !dbg !1068
  %567 = icmp ne i32 %566, 0, !dbg !1068
  %is_subnormal131 = and i1 %565, %567, !dbg !1068
  %568 = xor i1 %is_subnormal131, true, !dbg !1068
  %569 = and i1 true, %568, !dbg !1068
  %570 = and i1 %569, true, !dbg !1068
  %571 = bitcast float %div50 to i32, !dbg !1068
  %572 = and i32 %571, 2139095040, !dbg !1068
  %573 = icmp eq i32 %572, 0, !dbg !1068
  %574 = and i32 %571, 8388607, !dbg !1068
  %575 = icmp ne i32 %574, 0, !dbg !1068
  %is_subnormal132 = and i1 %573, %575, !dbg !1068
  %subnormal_cond133 = and i1 %570, %is_subnormal132, !dbg !1068
  br i1 %subnormal_cond133, label %576, label %578, !dbg !1068

576:                                              ; preds = %562
  %577 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1068
  br label %578, !dbg !1068

578:                                              ; preds = %562, %576
  %579 = load ptr, ptr %result.addr, align 8, !dbg !1068
  %arrayidx51 = getelementptr inbounds float, ptr %579, i64 6, !dbg !1068
  store float %div50, ptr %arrayidx51, align 4, !dbg !1069
  %580 = load ptr, ptr %result.addr, align 8, !dbg !1070
  %arrayidx52 = getelementptr inbounds float, ptr %580, i64 6, !dbg !1070
  %581 = load float, ptr %arrayidx52, align 4, !dbg !1070
  %call53 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %581) #3, !dbg !1071
  %582 = zext i1 %call53 to i64, !dbg !1071
  %cond54 = select i1 %call53, i32 2, i32 1, !dbg !1071
  %583 = load ptr, ptr %status.addr, align 8, !dbg !1072
  %arrayidx55 = getelementptr inbounds i32, ptr %583, i64 6, !dbg !1072
  store i32 %cond54, ptr %arrayidx55, align 4, !dbg !1073
  br label %if.end56, !dbg !1074

if.end56:                                         ; preds = %578, %if.end47
  %584 = load i32, ptr %idx, align 4, !dbg !1075
  %cmp57 = icmp eq i32 %584, 7, !dbg !1077
  br i1 %cmp57, label %if.then58, label %if.end68, !dbg !1077

if.then58:                                        ; preds = %if.end56
  %585 = load float, ptr %base, align 4, !dbg !1078
  %586 = bitcast float %585 to i32, !dbg !1080
  %587 = bitcast float %585 to i32, !dbg !1080
  %588 = and i32 %587, 2139095040, !dbg !1080
  %589 = icmp eq i32 %588, 2139095040, !dbg !1080
  %590 = and i32 %587, 8388607, !dbg !1080
  %591 = icmp ne i32 %590, 0, !dbg !1080
  %is_nan134 = and i1 %589, %591, !dbg !1080
  %592 = and i32 %586, 4194304, !dbg !1080
  %593 = icmp eq i32 %592, 0, !dbg !1080
  %is_snan135 = and i1 %is_nan134, %593, !dbg !1080
  %594 = or i1 %is_snan135, false, !dbg !1080
  %595 = bitcast float %585 to i32, !dbg !1080
  %596 = and i32 %595, 2147483647, !dbg !1080
  %is_zero136 = icmp eq i32 %596, 0, !dbg !1080
  %597 = and i1 %is_zero136, false, !dbg !1080
  %598 = bitcast float %585 to i32, !dbg !1080
  %599 = and i32 %598, 2139095040, !dbg !1080
  %600 = icmp eq i32 %599, 2139095040, !dbg !1080
  %601 = and i32 %598, 8388607, !dbg !1080
  %602 = icmp eq i32 %601, 0, !dbg !1080
  %is_inf137 = and i1 %600, %602, !dbg !1080
  %603 = and i1 %is_inf137, false, !dbg !1080
  %604 = or i1 %597, %603, !dbg !1080
  %605 = or i1 %594, %604, !dbg !1080
  br i1 %605, label %606, label %608, !dbg !1080

606:                                              ; preds = %if.then58
  %607 = atomicrmw add ptr addrspace(1) @fp_counters, i64 1 monotonic, align 8, !dbg !1080
  br label %608, !dbg !1080

608:                                              ; preds = %if.then58, %606
  %609 = bitcast float %585 to i32, !dbg !1080
  %610 = and i32 %609, 2139095040, !dbg !1080
  %is_finite138 = icmp ne i32 %610, 2139095040, !dbg !1080
  %611 = bitcast float %585 to i32, !dbg !1080
  %612 = and i32 %611, 2147483647, !dbg !1080
  %is_zero139 = icmp eq i32 %612, 0, !dbg !1080
  %613 = xor i1 %is_zero139, true, !dbg !1080
  %614 = and i1 %is_finite138, %613, !dbg !1080
  %divzero_cond140 = and i1 false, %614, !dbg !1080
  br i1 %divzero_cond140, label %615, label %617, !dbg !1080

615:                                              ; preds = %608
  %616 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 1), i64 1 monotonic, align 8, !dbg !1080
  br label %617, !dbg !1080

617:                                              ; preds = %608, %615
  %div59 = fdiv contract float %585, 0x4415AF1D80000000, !dbg !1080
  %618 = bitcast float %585 to i32, !dbg !1081
  %619 = and i32 %618, 2139095040, !dbg !1081
  %is_finite141 = icmp ne i32 %619, 2139095040, !dbg !1081
  %620 = and i1 true, %is_finite141, !dbg !1081
  %621 = and i1 %620, true, !dbg !1081
  %overflow_denom_nonzero142 = and i1 %621, true, !dbg !1081
  %622 = bitcast float %div59 to i32, !dbg !1081
  %623 = and i32 %622, 2139095040, !dbg !1081
  %624 = icmp eq i32 %623, 2139095040, !dbg !1081
  %625 = and i32 %622, 8388607, !dbg !1081
  %626 = icmp eq i32 %625, 0, !dbg !1081
  %is_inf143 = and i1 %624, %626, !dbg !1081
  %627 = bitcast float %div59 to i32, !dbg !1081
  %628 = and i32 %627, 2147483647, !dbg !1081
  %is_maxfinite144 = icmp eq i32 %628, 2139095039, !dbg !1081
  %629 = bitcast float %div59 to i32, !dbg !1081
  %630 = and i32 %629, -2147483648, !dbg !1081
  %631 = icmp eq i32 %630, 0, !dbg !1081
  %632 = icmp ne i32 %630, 0, !dbg !1081
  %is_pos_inf145 = and i1 %is_inf143, %631, !dbg !1081
  %is_neg_inf146 = and i1 %is_inf143, %632, !dbg !1081
  %is_pos_max147 = and i1 %is_maxfinite144, %631, !dbg !1081
  %is_neg_max148 = and i1 %is_maxfinite144, %632, !dbg !1081
  %overflow_cond149 = and i1 %overflow_denom_nonzero142, %is_inf143, !dbg !1081
  br i1 %overflow_cond149, label %633, label %635, !dbg !1081

633:                                              ; preds = %617
  %634 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 2), i64 1 monotonic, align 8, !dbg !1081
  br label %635, !dbg !1081

635:                                              ; preds = %617, %633
  %636 = bitcast float %585 to i32, !dbg !1081
  %637 = and i32 %636, 2139095040, !dbg !1081
  %638 = icmp eq i32 %637, 0, !dbg !1081
  %639 = and i32 %636, 8388607, !dbg !1081
  %640 = icmp ne i32 %639, 0, !dbg !1081
  %is_subnormal150 = and i1 %638, %640, !dbg !1081
  %641 = xor i1 %is_subnormal150, true, !dbg !1081
  %642 = and i1 true, %641, !dbg !1081
  %643 = and i1 %642, true, !dbg !1081
  %644 = bitcast float %div59 to i32, !dbg !1081
  %645 = and i32 %644, 2139095040, !dbg !1081
  %646 = icmp eq i32 %645, 0, !dbg !1081
  %647 = and i32 %644, 8388607, !dbg !1081
  %648 = icmp ne i32 %647, 0, !dbg !1081
  %is_subnormal151 = and i1 %646, %648, !dbg !1081
  %649 = bitcast float %div59 to i32, !dbg !1081
  %650 = and i32 %649, 2147483647, !dbg !1081
  %is_zero152 = icmp eq i32 %650, 0, !dbg !1081
  %651 = bitcast float %585 to i32, !dbg !1081
  %652 = and i32 %651, 2147483647, !dbg !1081
  %is_zero153 = icmp eq i32 %652, 0, !dbg !1081
  %653 = xor i1 %is_zero153, true, !dbg !1081
  %654 = and i1 %653, true, !dbg !1081
  %655 = and i1 %is_zero152, %654, !dbg !1081
  %is_tiny154 = or i1 %is_subnormal151, %655, !dbg !1081
  %underflow_cond155 = and i1 %643, %is_tiny154, !dbg !1081
  br i1 %underflow_cond155, label %656, label %658, !dbg !1081

656:                                              ; preds = %635
  %657 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 3), i64 1 monotonic, align 8, !dbg !1081
  br label %658, !dbg !1081

658:                                              ; preds = %635, %656
  %659 = bitcast float %585 to i32, !dbg !1081
  %660 = and i32 %659, 2139095040, !dbg !1081
  %661 = icmp eq i32 %660, 0, !dbg !1081
  %662 = and i32 %659, 8388607, !dbg !1081
  %663 = icmp ne i32 %662, 0, !dbg !1081
  %is_subnormal156 = and i1 %661, %663, !dbg !1081
  %664 = xor i1 %is_subnormal156, true, !dbg !1081
  %665 = and i1 true, %664, !dbg !1081
  %666 = and i1 %665, true, !dbg !1081
  %667 = bitcast float %div59 to i32, !dbg !1081
  %668 = and i32 %667, 2139095040, !dbg !1081
  %669 = icmp eq i32 %668, 0, !dbg !1081
  %670 = and i32 %667, 8388607, !dbg !1081
  %671 = icmp ne i32 %670, 0, !dbg !1081
  %is_subnormal157 = and i1 %669, %671, !dbg !1081
  %subnormal_cond158 = and i1 %666, %is_subnormal157, !dbg !1081
  br i1 %subnormal_cond158, label %672, label %674, !dbg !1081

672:                                              ; preds = %658
  %673 = atomicrmw add ptr addrspace(1) getelementptr inbounds ([6 x i64], ptr addrspace(1) @fp_counters, i32 0, i32 5), i64 1 monotonic, align 8, !dbg !1081
  br label %674, !dbg !1081

674:                                              ; preds = %658, %672
  %675 = load ptr, ptr %result.addr, align 8, !dbg !1081
  %arrayidx60 = getelementptr inbounds float, ptr %675, i64 7, !dbg !1081
  store float %div59, ptr %arrayidx60, align 4, !dbg !1082
  %676 = load ptr, ptr %result.addr, align 8, !dbg !1083
  %arrayidx61 = getelementptr inbounds float, ptr %676, i64 7, !dbg !1083
  %677 = load float, ptr %arrayidx61, align 4, !dbg !1083
  %cmp62 = fcmp contract oeq float %677, 0.000000e+00, !dbg !1084
  br i1 %cmp62, label %cond.true, label %cond.false, !dbg !1085

cond.true:                                        ; preds = %674
  br label %cond.end, !dbg !1085

cond.false:                                       ; preds = %674
  %678 = load ptr, ptr %result.addr, align 8, !dbg !1086
  %arrayidx63 = getelementptr inbounds float, ptr %678, i64 7, !dbg !1086
  %679 = load float, ptr %arrayidx63, align 4, !dbg !1086
  %call64 = call noundef zeroext i1 @_Z12is_subnormalf(float noundef %679) #3, !dbg !1087
  %680 = zext i1 %call64 to i64, !dbg !1087
  %cond65 = select i1 %call64, i32 2, i32 1, !dbg !1087
  br label %cond.end, !dbg !1085

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond66 = phi i32 [ 0, %cond.true ], [ %cond65, %cond.false ], !dbg !1085
  %681 = load ptr, ptr %status.addr, align 8, !dbg !1088
  %arrayidx67 = getelementptr inbounds i32, ptr %681, i64 7, !dbg !1088
  store i32 %cond66, ptr %arrayidx67, align 4, !dbg !1089
  br label %if.end68, !dbg !1090

if.end68:                                         ; preds = %cond.end, %if.end56
  ret void, !dbg !1091
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.nvvm.read.ptx.sreg.tid.x() #1

attributes #0 = { convergent noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { convergent mustprogress noinline norecurse nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_80" "target-features"="+ptx87,+sm_80" "uniform-work-group-size"="true" }
attributes #3 = { convergent nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!947, !948}
!nvvmir.version = !{!949}
!llvm.module.flags = !{!950, !951, !952, !953, !954, !955}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !27, imports: !91, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "tests/basic_tests/underflow/gradual.cu", directory: "/home/users/sislam3/SBAC-PAD")
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
!91 = !{!92, !99, !104, !106, !108, !110, !112, !116, !118, !120, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !148, !150, !152, !154, !158, !163, !165, !167, !172, !176, !178, !180, !182, !184, !186, !188, !190, !192, !197, !201, !203, !208, !212, !214, !216, !218, !220, !222, !226, !228, !230, !235, !243, !247, !249, !251, !253, !255, !259, !261, !263, !267, !269, !271, !273, !275, !277, !279, !281, !283, !285, !289, !295, !297, !299, !303, !305, !307, !309, !311, !313, !315, !317, !321, !325, !327, !329, !334, !336, !338, !340, !342, !344, !346, !349, !351, !353, !355, !360, !362, !364, !366, !368, !370, !372, !374, !376, !378, !380, !382, !386, !388, !390, !392, !394, !396, !398, !400, !402, !404, !406, !408, !410, !412, !414, !416, !420, !422, !426, !428, !430, !432, !434, !436, !438, !440, !442, !444, !448, !450, !454, !456, !458, !460, !464, !466, !470, !472, !474, !476, !478, !480, !482, !484, !486, !488, !490, !492, !494, !498, !500, !504, !506, !508, !510, !512, !514, !518, !520, !522, !524, !526, !528, !530, !534, !538, !540, !542, !544, !546, !550, !552, !556, !558, !560, !562, !564, !566, !568, !572, !574, !578, !580, !582, !586, !588, !590, !592, !594, !596, !598, !602, !606, !612, !616, !624, !629, !631, !633, !637, !641, !651, !653, !657, !661, !665, !670, !672, !676, !680, !684, !692, !696, !700, !702, !706, !710, !714, !720, !724, !728, !730, !738, !742, !749, !751, !753, !757, !761, !765, !769, !773, !777, !778, !779, !780, !782, !783, !784, !785, !786, !787, !788, !790, !791, !792, !793, !794, !795, !796, !797, !802, !803, !804, !805, !806, !807, !808, !809, !810, !811, !812, !813, !814, !815, !816, !817, !818, !819, !820, !821, !822, !823, !824, !825, !826, !830, !832, !834, !836, !838, !840, !842, !844, !846, !848, !850, !852, !854, !856, !858, !860, !862, !865, !867, !869, !871, !873, !875, !877, !879, !881, !883, !885, !887, !889, !891, !893, !895, !897, !899, !901, !903, !905, !907, !909, !911, !913, !915, !917, !919, !921, !923, !925, !927, !929, !931, !933, !935, !937, !939, !940, !941, !945}
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
!859 = !DISubprogram(name: "expf", linkageName: "_ZL4expff", scope: !828, file: !828, line: 113, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!860 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !861, file: !829, line: 459)
!861 = !DISubprogram(name: "expm1f", linkageName: "_ZL6expm1ff", scope: !828, file: !828, line: 115, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
!862 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !93, entity: !863, file: !829, line: 460)
!863 = distinct !DISubprogram(name: "fabsf", linkageName: "_ZL5fabsff", scope: !828, file: !828, line: 116, type: !101, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !864)
!864 = !{}
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
!900 = !DISubprogram(name: "logf", linkageName: "_ZL4logff", scope: !828, file: !828, line: 186, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
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
!912 = !DISubprogram(name: "powf", linkageName: "_ZL4powfff", scope: !828, file: !828, line: 235, type: !114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
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
!930 = !DISubprogram(name: "sqrtf", linkageName: "_ZL5sqrtff", scope: !828, file: !828, line: 318, type: !101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit)
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
!947 = !{!"clang version 22.1.5 (https://github.com/llvm/llvm-project.git 5ea218a153f4d2f815b8244eab3e4b4ba5e00e6c)"}
!948 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!949 = !{i32 2, i32 0}
!950 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 8]}
!951 = !{i32 7, !"Dwarf Version", i32 2}
!952 = !{i32 2, !"Debug Info Version", i32 3}
!953 = !{i32 1, !"wchar_size", i32 4}
!954 = !{i32 4, !"nvvm-reflect-ftz", i32 0}
!955 = !{i32 7, !"frame-pointer", i32 2}
!956 = distinct !DISubprogram(name: "is_subnormal", linkageName: "_Z12is_subnormalf", scope: !1, file: !1, line: 5, type: !169, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !864)
!957 = !DILocalVariable(name: "x", arg: 1, scope: !956, file: !1, line: 5, type: !103)
!958 = !DILocation(line: 5, column: 36, scope: !956)
!959 = !DILocation(line: 6, column: 13, scope: !956)
!960 = !DILocation(line: 6, column: 15, scope: !956)
!961 = !DILocation(line: 6, column: 24, scope: !956)
!962 = !DILocation(line: 6, column: 34, scope: !956)
!963 = !DILocalVariable(name: "__a", arg: 1, scope: !863, file: !828, line: 116, type: !103)
!964 = !DILocation(line: 116, column: 30, scope: !863, inlinedAt: !965)
!965 = distinct !DILocation(line: 6, column: 28, scope: !956)
!966 = !DILocation(line: 116, column: 55, scope: !863, inlinedAt: !965)
!967 = !DILocation(line: 116, column: 44, scope: !863, inlinedAt: !965)
!968 = !DILocation(line: 6, column: 37, scope: !956)
!969 = !DILocation(line: 0, scope: !956)
!970 = !DILocation(line: 6, column: 5, scope: !956)
!971 = distinct !DISubprogram(name: "testGradualUnderflow", linkageName: "_Z20testGradualUnderflowPfPi", scope: !1, file: !1, line: 9, type: !972, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !864)
!972 = !DISubroutineType(types: !973)
!973 = !{null, !234, !162}
!974 = !DILocalVariable(name: "result", arg: 1, scope: !971, file: !1, line: 9, type: !234)
!975 = !DILocation(line: 9, column: 45, scope: !971)
!976 = !DILocalVariable(name: "status", arg: 2, scope: !971, file: !1, line: 9, type: !162)
!977 = !DILocation(line: 9, column: 58, scope: !971)
!978 = !DILocalVariable(name: "idx", scope: !971, file: !1, line: 10, type: !98)
!979 = !DILocation(line: 10, column: 9, scope: !971)
!980 = !DILocation(line: 53, column: 27, scope: !981, inlinedAt: !982)
!981 = distinct !DISubprogram(name: "__fetch_builtin_x", linkageName: "_ZN26__cuda_builtin_threadIdx_t17__fetch_builtin_xEv", scope: !60, file: !61, line: 53, type: !64, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !63)
!982 = distinct !DILocation(line: 10, column: 15, scope: !971)
!983 = !DILocalVariable(name: "base", scope: !971, file: !1, line: 12, type: !103)
!984 = !DILocation(line: 12, column: 11, scope: !971)
!985 = !DILocation(line: 17, column: 9, scope: !986)
!986 = distinct !DILexicalBlock(scope: !971, file: !1, line: 17, column: 9)
!987 = !DILocation(line: 17, column: 13, scope: !986)
!988 = !DILocation(line: 18, column: 21, scope: !989)
!989 = distinct !DILexicalBlock(scope: !986, file: !1, line: 17, column: 19)
!990 = !DILocation(line: 18, column: 9, scope: !989)
!991 = !DILocation(line: 18, column: 19, scope: !989)
!992 = !DILocation(line: 19, column: 34, scope: !989)
!993 = !DILocation(line: 19, column: 21, scope: !989)
!994 = !DILocation(line: 19, column: 9, scope: !989)
!995 = !DILocation(line: 19, column: 19, scope: !989)
!996 = !DILocation(line: 20, column: 5, scope: !989)
!997 = !DILocation(line: 22, column: 9, scope: !998)
!998 = distinct !DILexicalBlock(scope: !971, file: !1, line: 22, column: 9)
!999 = !DILocation(line: 22, column: 13, scope: !998)
!1000 = !DILocation(line: 23, column: 21, scope: !1001)
!1001 = distinct !DILexicalBlock(scope: !998, file: !1, line: 22, column: 19)
!1002 = !DILocation(line: 23, column: 26, scope: !1001)
!1003 = !DILocation(line: 23, column: 9, scope: !1001)
!1004 = !DILocation(line: 23, column: 19, scope: !1001)
!1005 = !DILocation(line: 24, column: 34, scope: !1001)
!1006 = !DILocation(line: 24, column: 21, scope: !1001)
!1007 = !DILocation(line: 24, column: 9, scope: !1001)
!1008 = !DILocation(line: 24, column: 19, scope: !1001)
!1009 = !DILocation(line: 25, column: 5, scope: !1001)
!1010 = !DILocation(line: 27, column: 9, scope: !1011)
!1011 = distinct !DILexicalBlock(scope: !971, file: !1, line: 27, column: 9)
!1012 = !DILocation(line: 27, column: 13, scope: !1011)
!1013 = !DILocation(line: 28, column: 21, scope: !1014)
!1014 = distinct !DILexicalBlock(scope: !1011, file: !1, line: 27, column: 19)
!1015 = !DILocation(line: 28, column: 26, scope: !1014)
!1016 = !DILocation(line: 28, column: 9, scope: !1014)
!1017 = !DILocation(line: 28, column: 19, scope: !1014)
!1018 = !DILocation(line: 29, column: 34, scope: !1014)
!1019 = !DILocation(line: 29, column: 21, scope: !1014)
!1020 = !DILocation(line: 29, column: 9, scope: !1014)
!1021 = !DILocation(line: 29, column: 19, scope: !1014)
!1022 = !DILocation(line: 30, column: 5, scope: !1014)
!1023 = !DILocation(line: 32, column: 9, scope: !1024)
!1024 = distinct !DILexicalBlock(scope: !971, file: !1, line: 32, column: 9)
!1025 = !DILocation(line: 32, column: 13, scope: !1024)
!1026 = !DILocation(line: 33, column: 21, scope: !1027)
!1027 = distinct !DILexicalBlock(scope: !1024, file: !1, line: 32, column: 19)
!1028 = !DILocation(line: 33, column: 26, scope: !1027)
!1029 = !DILocation(line: 33, column: 9, scope: !1027)
!1030 = !DILocation(line: 33, column: 19, scope: !1027)
!1031 = !DILocation(line: 34, column: 34, scope: !1027)
!1032 = !DILocation(line: 34, column: 21, scope: !1027)
!1033 = !DILocation(line: 34, column: 9, scope: !1027)
!1034 = !DILocation(line: 34, column: 19, scope: !1027)
!1035 = !DILocation(line: 35, column: 5, scope: !1027)
!1036 = !DILocation(line: 37, column: 9, scope: !1037)
!1037 = distinct !DILexicalBlock(scope: !971, file: !1, line: 37, column: 9)
!1038 = !DILocation(line: 37, column: 13, scope: !1037)
!1039 = !DILocation(line: 38, column: 21, scope: !1040)
!1040 = distinct !DILexicalBlock(scope: !1037, file: !1, line: 37, column: 19)
!1041 = !DILocation(line: 38, column: 26, scope: !1040)
!1042 = !DILocation(line: 38, column: 9, scope: !1040)
!1043 = !DILocation(line: 38, column: 19, scope: !1040)
!1044 = !DILocation(line: 39, column: 34, scope: !1040)
!1045 = !DILocation(line: 39, column: 21, scope: !1040)
!1046 = !DILocation(line: 39, column: 9, scope: !1040)
!1047 = !DILocation(line: 39, column: 19, scope: !1040)
!1048 = !DILocation(line: 40, column: 5, scope: !1040)
!1049 = !DILocation(line: 42, column: 9, scope: !1050)
!1050 = distinct !DILexicalBlock(scope: !971, file: !1, line: 42, column: 9)
!1051 = !DILocation(line: 42, column: 13, scope: !1050)
!1052 = !DILocation(line: 43, column: 21, scope: !1053)
!1053 = distinct !DILexicalBlock(scope: !1050, file: !1, line: 42, column: 19)
!1054 = !DILocation(line: 43, column: 26, scope: !1053)
!1055 = !DILocation(line: 43, column: 9, scope: !1053)
!1056 = !DILocation(line: 43, column: 19, scope: !1053)
!1057 = !DILocation(line: 44, column: 34, scope: !1053)
!1058 = !DILocation(line: 44, column: 21, scope: !1053)
!1059 = !DILocation(line: 44, column: 9, scope: !1053)
!1060 = !DILocation(line: 44, column: 19, scope: !1053)
!1061 = !DILocation(line: 45, column: 5, scope: !1053)
!1062 = !DILocation(line: 47, column: 9, scope: !1063)
!1063 = distinct !DILexicalBlock(scope: !971, file: !1, line: 47, column: 9)
!1064 = !DILocation(line: 47, column: 13, scope: !1063)
!1065 = !DILocation(line: 48, column: 21, scope: !1066)
!1066 = distinct !DILexicalBlock(scope: !1063, file: !1, line: 47, column: 19)
!1067 = !DILocation(line: 48, column: 26, scope: !1066)
!1068 = !DILocation(line: 48, column: 9, scope: !1066)
!1069 = !DILocation(line: 48, column: 19, scope: !1066)
!1070 = !DILocation(line: 49, column: 34, scope: !1066)
!1071 = !DILocation(line: 49, column: 21, scope: !1066)
!1072 = !DILocation(line: 49, column: 9, scope: !1066)
!1073 = !DILocation(line: 49, column: 19, scope: !1066)
!1074 = !DILocation(line: 50, column: 5, scope: !1066)
!1075 = !DILocation(line: 52, column: 9, scope: !1076)
!1076 = distinct !DILexicalBlock(scope: !971, file: !1, line: 52, column: 9)
!1077 = !DILocation(line: 52, column: 13, scope: !1076)
!1078 = !DILocation(line: 53, column: 21, scope: !1079)
!1079 = distinct !DILexicalBlock(scope: !1076, file: !1, line: 52, column: 19)
!1080 = !DILocation(line: 53, column: 26, scope: !1079)
!1081 = !DILocation(line: 53, column: 9, scope: !1079)
!1082 = !DILocation(line: 53, column: 19, scope: !1079)
!1083 = !DILocation(line: 54, column: 22, scope: !1079)
!1084 = !DILocation(line: 54, column: 32, scope: !1079)
!1085 = !DILocation(line: 54, column: 21, scope: !1079)
!1086 = !DILocation(line: 54, column: 61, scope: !1079)
!1087 = !DILocation(line: 54, column: 48, scope: !1079)
!1088 = !DILocation(line: 54, column: 9, scope: !1079)
!1089 = !DILocation(line: 54, column: 19, scope: !1079)
!1090 = !DILocation(line: 55, column: 5, scope: !1079)
!1091 = !DILocation(line: 56, column: 1, scope: !971)
