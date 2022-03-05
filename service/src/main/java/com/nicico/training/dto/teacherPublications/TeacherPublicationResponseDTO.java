package com.nicico.training.dto.teacherPublications;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.util.List;

@Setter
@Getter
public class TeacherPublicationResponseDTO extends BaseResponse {
    List<ElsPublicationDTO.Info> publicationDTOInfoList;
}
