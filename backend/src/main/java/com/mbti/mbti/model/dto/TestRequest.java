package com.mbti.mbti.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class TestRequest {
    private String userName;
    private List<TestAnswer> answers;
}
