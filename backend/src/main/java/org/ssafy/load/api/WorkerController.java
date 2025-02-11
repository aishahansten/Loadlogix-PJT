package org.ssafy.load.api;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.ssafy.load.application.LoadTaskService;
import org.ssafy.load.application.WorkerService;
import org.ssafy.load.common.dto.Response;
import org.ssafy.load.dto.request.worker.LoginRequest;
import org.ssafy.load.dto.request.worker.SignUpRequest;
import org.ssafy.load.dto.response.worker.LoginResponse;
import org.ssafy.load.dto.response.worker.SignUpResponse;
import org.ssafy.load.dto.response.worker.WorkerInfoResponse;
import org.ssafy.load.security.JwtTokenProvider;


@RequiredArgsConstructor
@RestController
@RequestMapping("/worker")
public class WorkerController {

    public final WorkerService workerService;
    public final JwtTokenProvider jwtTokenProvider;
    public final LoadTaskService loadTaskService;

    @PostMapping("/signup")
    public Response<SignUpResponse> signup(@RequestBody SignUpRequest signupRequest) {
        return Response.success(workerService.signup(signupRequest));
    }

    @PostMapping("/login")
    public Response<LoginResponse> login(@RequestBody LoginRequest loginRequest) {
        return Response.success(workerService.login(loginRequest));
    }

    @PutMapping("/ready")
    public Response<Boolean> setWorkerReady(@RequestHeader(name="Authorization") String token) {
        Long workerId = jwtTokenProvider.getId(token);
        return Response.success(loadTaskService.setReadyCompletedWorker(workerId));
    }

    @GetMapping("/info")
    public Response<WorkerInfoResponse> getWorkerInfo(@RequestHeader(name="Authorization") String token){
        Long workerId = jwtTokenProvider.getId(token);
        return Response.success(workerService.getWorkerInfo(workerId));
    }
}