package com.mbti.result.model.dto;

import com.mbti.answer.model.dto.Answer;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Result {
    private Long id;
    private String userName;
    private String resultType;
    private Integer eScore;
    private Integer iScore;
    private Integer sScore;
    private Integer nScore;
    private Integer tScore;
    private Integer fScore;
    private Integer jScore;
    private Integer pScore;
    private String createdAt;

    // 조인용 추가 필드
    private String typeName;
    private String description;
    private String characteristics;
    private String strengths;
    private String weaknesses;

    // 답변 목록
    private List<Answer> answers;
}
