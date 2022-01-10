package com.nicico.training.controller.util;


import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;


@Component
public class AppUtils {
//    public static PageDTO listToPagination(int page, int size, Page<?> pageList, List<?> dtoList) {
//
//        PageDTO pageDTO = new PageDTO();
//        PaginationDto paginationDto = new PaginationDto();
//
//        paginationDto.setCurrent(page);
//        paginationDto.setSize(size);
//        paginationDto.setLast(pageList.getTotalPages()-1);
//        paginationDto.setTotal(pageList.getTotalPages());
//        paginationDto.setTotalItems(pageList.getTotalElements());
//        pageDTO.setData(dtoList);
//        pageDTO.setPagination(paginationDto);
//
//
//        return pageDTO;
//    }
//    public static PageDTO getPageDto( int page, int size,List<?> list) {
//
//        int totalPage = 0;
//        if (list.size() > 0) {
//            if ((list.size() % size) == 0) {
//                totalPage = list.size() / size;
//            } else {
//                totalPage = list.size() / size;
//                totalPage++;
//            }
//        }
//        PaginationDto paginationDto = new PaginationDto();
//
//        PageDTO pageDTO = new PageDTO();
//        paginationDto.setCurrent(page);
//        paginationDto.setSize(size);
//
//        if (!list.isEmpty()) {
//            paginationDto.setTotal(getTotalPages(list.size(), size));
//            paginationDto.setTotalItems((long) list.size());
//            paginationDto.setLast(getTotalPages(list.size(), size)-1);
//
//        } else {
//            paginationDto.setTotalItems(0L);
//            paginationDto.setTotal(getTotalPages(0, 0));
//            paginationDto.setLast(0);
//
//        }
//        if (page >= totalPage) {
//            pageDTO.setData(new ArrayList<>());
//        } else {
//            if ((page * size) + size <= list.size())
//                pageDTO.setData(list.subList(page * size, (page * size) + size));
//            else
//                pageDTO.setData(list.subList(page * size, list.size()));
//        }
//        pageDTO.setPagination(paginationDto);
//        return pageDTO;
//    }

    public static int getTotalPages(int total, int size) {
        return size == 0 ? 1 : (int) Math.ceil((double) total / (double) size);
    }

    public static String getPrefix(String gender) {
        switch (gender) {
            case "مرد":
            case "Male":
            case "آقا": {
                return "جناب آقای ";

            }
            case "زن":
            case "Female":
            case "خانم": {
                return "سرکار خانم ";
            }
            default:
                return "جناب آقای/سرکار خانم ";
        }
    }

    //    @Qualifier("intToEnum")
//    public static Gender toEnum(int key){
//        return Arrays.stream(Gender.values())
//                .filter(e -> e.getKey()== key)
//                .findFirst()
//                .orElseThrow(() -> new IllegalStateException(String.format("Unsupported type %s.", key)));
//
//    }
//
//    @Qualifier("enumToInt")
//    public static int toInteger(Gender gender){
//
//        return   gender.getKey();
//
//    }
    public static String getTenantId() {
        return "Training";
    }

}
