package com.nicico.training.dto;

import com.nicico.copper.common.dto.search.SearchDTO;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ElsSearchDTO {
    private String nationalCode;
  private  List<ElsSearch> elsSearchList;
}
